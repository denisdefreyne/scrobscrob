//
//	BSProtocolHandler.m
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import "BSProtocolHandler.h"

#import "CocoaCryptoHashing.h"
#import "BSTrackQueue.h"
#import "BSTrack.h"


NSString *kClientID			= @"tst";
NSString *kClientVersion	= @"1.0";

NSString *kHandshakeAction	= @"BS Handshake Action";
NSString *kSubmitAction		= @"BS Submit Action";

NSString *BSUserAuthenticationFailedNotificationName		= @"BS UserAuthenticationFailed Notification";
NSString *BSPasswordAuthenticationFailedNotificationName	= @"BS PasswordAuthenticationFailed Notification";
NSString *BSNetworkErrorReceivedNotificationName			= @"BS NetworkErrorReceived Notification";

@interface BSProtocolHandler (Private)

- (NSMutableData *)data;
- (void)setData:(NSMutableData *)aData;

- (void)notifyUserAuthenticationFailure;
- (void)notifyPasswordAuthenticationFailure;
- (void)notifyNetworkError;

- (NSString *)stringForTracks:(NSArray *)aTracks;

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse;
- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)aData;
- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection;
- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)aError;

- (void)handleHandshakeResponse:(NSString *)aResponse;
- (void)handleSubmitResponse:(NSString *)aResponse;

- (NSString *)singleHashedPassword;
- (void)setSingleHashedPassword:(NSString *)aSingleHashedPassword;

- (NSString *)doubleHashedPassword;
- (void)setDoubleHashedPassword:(NSString *)aDoubleHashedPassword;

- (NSURL *)submitURL;
- (void)setSubmitURL:(NSURL *)aSubmitURL;

@end

@implementation BSProtocolHandler (Private)

- (NSMutableData *)data
{
	return mData;
}

- (void)setData:(NSMutableData *)aData
{
	if(mData == aData)
		return;
	
	[mData release];
	mData = [aData retain];
}

#pragma mark -

- (void)notifyUserAuthenticationFailure
{
	[[NSNotificationCenter defaultCenter] postNotificationName:BSUserAuthenticationFailedNotificationName object:nil];
}

- (void)notifyPasswordAuthenticationFailure
{
	[[NSNotificationCenter defaultCenter] postNotificationName:BSPasswordAuthenticationFailedNotificationName object:nil];
}

- (void)notifyNetworkError
{
	[[NSNotificationCenter defaultCenter] postNotificationName:BSNetworkErrorReceivedNotificationName object:nil];
}

#pragma mark -

- (NSString *)stringForTracks:(NSArray *)aTracks
{
	NSMutableString *string = [[[NSMutableString alloc] init] autorelease];
	
	[string appendString:@"u="];
	[string appendString:[mUsername stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	
	[string appendString:@"&s="];
	[string appendString:mDoubleHashedPassword];
	
	NSEnumerator *trackEnumerator = [aTracks objectEnumerator];
	BSTrack *track;
	while(track = [trackEnumerator nextObject])
	{
		[string appendString:@"&a[0]="];
		[string appendString:[[track artist] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
		[string appendString:@"&t[0]="];
		[string appendString:[[track name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
		[string appendString:@"&b[0]="];
		[string appendString:[[track album] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
		
		[string appendString:@"&m[0]="];
		
		[string appendString:@"&l[0]="];
		[string appendString:[[NSNumber numberWithInt:[track totalTime]] description]];
		
		[string appendString:@"&i[0]="];
		[string appendString:
			[
				[NSString stringWithFormat:@"%4d-%2d-%2d %2d:%2d:%2d",
					[[track date] yearOfCommonEra],
					[[track date] monthOfYear],
					[[track date] dayOfMonth],
					[[track date] hourOfDay],
					[[track date] minuteOfHour],
					[[track date] secondOfMinute]
				]
			stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
		];
	}
	
	return string;
}

#pragma mark -

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse
{
	[self setData:[[[NSMutableData alloc] init] autorelease]];
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)aData
{
	[mData appendData:aData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
	// Convert data to string
	NSString *string = [[[NSString alloc] initWithData:mData encoding:NSUTF8StringEncoding] autorelease];
//	NSLog(@"*** RECEIVED DATA:\n==========\n%@\n==========", string);
	
	// Check action
	if(mAction == kHandshakeAction)
		[self handleHandshakeResponse:string];
	else if(mAction == kSubmitAction)
		[self handleSubmitResponse:string];
	else
		[self notifyNetworkError];
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)aError
{
	[self notifyNetworkError];
}

#pragma mark -

- (NSArray *)componentsForResponse:(NSString *)aResponse
{
	// Split string
	NSArray *components = [aResponse componentsSeparatedByString:@"\n"];
	
	// Filter array
	NSMutableArray	*filteredComponents = [[[NSMutableArray alloc] init] autorelease];
	NSEnumerator	*enumerator = [components objectEnumerator];
	NSCharacterSet	*blankCharacterSet = [NSCharacterSet characterSetWithCharactersInString:@"\n\r \t"];
	NSString		*string;
	while(string = [enumerator nextObject])
	{
		NSString *trimmedString = [string stringByTrimmingCharactersInSet:blankCharacterSet];
		if([trimmedString length] != 0)
			[filteredComponents addObject:trimmedString];
	}
	NSLog(@"[PH] Response: %@", filteredComponents);
	
	return filteredComponents;
}

- (void)handleHandshakeResponse:(NSString *)aResponse
{
	// Split response
	NSArray *components = [self componentsForResponse:aResponse];
	
	// Check
	if([components count] != 4 && [components count] != 2)
	{
		[self notifyNetworkError];
		return;
	}
	
	// Get first component
	NSString *firstComponent = [components objectAtIndex:0];
	
	// Check whether we have an error condition
	if([components count] == 2)
	{
		// --------------------
		// FAILED <reason>
		// INTERVAL <n>
		// --------------------
		// BADUSER
		// INTERVAL <n>
		// --------------------
		
		if([firstComponent hasPrefix:@"FAILED"])
			[self notifyNetworkError];
		else if([firstComponent hasPrefix:@"BADUSER"])
			[self notifyUserAuthenticationFailure];
		else
			[self notifyNetworkError];
		return;
	}
	
	// --------------------
	// UPDTODATE
	// <md5>
	// <url>
	// INTERVAL <n>
	// --------------------
	// UPDATE <url>
	// <md5>
	// <url>
	// INTERVAL <n>
	// --------------------
	
	// TODO Check whether the response is in the correct format
	;
	
	// Extract MD5 challenge, URL to submit script, and interval
	NSString	*md5Challenge	= [components objectAtIndex:1];
	NSURL		*submitURL		= [NSURL URLWithString:[components objectAtIndex:2]];
	double		interval		= (double)[[[components objectAtIndex:3] substringFromIndex:9] intValue];
	
	// Store what's necessary
	[self setDoubleHashedPassword:[[NSString stringWithFormat:@"%@%@", mSingleHashedPassword, md5Challenge] md5HexHash]];
	[self setSubmitURL:submitURL];
	
	// Notify track queue
	[mTrackQueue submitIntervalReceived:[NSNumber numberWithDouble:interval]];
	
	NSLog(@"[PH] Logged in.");
	[mTrackQueue resume];
	mIsLoggedIn = YES;
}

- (void)handleSubmitResponse:(NSString *)aResponse
{
	// Split response
	NSArray *components = [self componentsForResponse:aResponse];
	
	// Check
	if([components count] != 2)
	{
		[mTrackQueue queueOrSubmitTracks:mTracks];
		[mTracks removeAllObjects];
		
		[self notifyNetworkError];
		
		return;
	}
	
	// Get first component
	NSString *firstComponent = [components objectAtIndex:0];
	
	// Check whether we have an error condition
	if(![firstComponent isEqualToString:@"OK"])
	{
		// --------------------
		// FAILED <reason>
		// INTERVAL <n>
		// --------------------
		// BADAUTH
		// INTERVAL <n>
		// --------------------
		
		[mTrackQueue queueOrSubmitTracks:mTracks];
		[mTracks removeAllObjects];
		
		if([firstComponent hasPrefix:@"FAILED"])
			[self notifyNetworkError];
		else if([firstComponent hasPrefix:@"BADAUTH"])
			[self notifyPasswordAuthenticationFailure];
		else
			[self notifyNetworkError];
		
		return;
	}
	
	// --------------------
	// OK
	// INTERVAL <n>
	// --------------------
	
	// Check whether the response is in the correct format
	if(![[components objectAtIndex:1] hasPrefix:@"INTERVAL "])
	{
		[mTrackQueue queueOrSubmitTracks:mTracks];
		[mTracks removeAllObjects];
		
		[self notifyNetworkError];
		
		return;
	}
	
	// Extract interval
	double interval = (double)[[[components objectAtIndex:1] substringFromIndex:9] intValue];
	
	// Notify track queue
	[mTracks removeAllObjects];
	[mTrackQueue submitIntervalReceived:[NSNumber numberWithDouble:interval]];
}

#pragma mark -

- (NSString *)username
{
	return mUsername;
}

- (void)setUsername:(NSString *)aUsername
{
	if(mUsername == aUsername)
		return;
	
	[mUsername release];
	mUsername = [aUsername retain];
}

- (NSString *)singleHashedPassword
{
	return mSingleHashedPassword;
}

- (void)setSingleHashedPassword:(NSString *)aSingleHashedPassword
{
	if(mSingleHashedPassword == aSingleHashedPassword)
		return;
	
	[mSingleHashedPassword release];
	mSingleHashedPassword = [aSingleHashedPassword retain];
}

- (NSString *)doubleHashedPassword
{
	return mDoubleHashedPassword;
}

- (void)setDoubleHashedPassword:(NSString *)aDoubleHashedPassword
{
	if(mDoubleHashedPassword == aDoubleHashedPassword)
		return;
	
	[mDoubleHashedPassword release];
	mDoubleHashedPassword = [aDoubleHashedPassword retain];
}

- (NSURL *)submitURL
{
	return mSubmitURL;
}

- (void)setSubmitURL:(NSURL *)aSubmitURL
{
	if(mSubmitURL == aSubmitURL)
		return;
	
	[mSubmitURL release];
	mSubmitURL = [aSubmitURL retain];
}

@end

@implementation BSProtocolHandler

- (id)init
{
	if(self = [super init])
	{
		mIsLoggedIn = NO;
		mTracks = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)dealloc
{
	[self setData:nil];
	[self setTrackQueue:nil];
	[mTracks release];
	
	[super dealloc];
}

#pragma mark -

- (BOOL)isLoggedIn
{
	return mIsLoggedIn;
}

- (NSString *)username
{
	return mUsername;
}

#pragma mark -

- (void)loginWithUsername:(NSString *)aUsername password:(NSString *)aPassword
{
	// Create request
	NSString		*urlString	= [NSString stringWithFormat:@"http://post.audioscrobbler.com/?hs=true&p=1.1&c=%@&v=%@&u=%@", kClientID, kClientVersion, aUsername];
	NSURLRequest	*request	= [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	
	// Set action
	mAction = kHandshakeAction;
	
	// Store username and password
	[self setUsername:aUsername];
	[self setSingleHashedPassword:[aPassword md5HexHash]];
	
	// Create connection
	NSURLConnection	*connection	= [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if(!connection)
	{
		[self notifyNetworkError];
		return;
	}
}

- (void)submitTracks:(NSArray *)aTracks
{
	// Store tracks
	[mTracks addObjectsFromArray:aTracks];
	
	// Convert tracks into data
	NSString *string = [self stringForTracks:aTracks];
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	
	// Create request
	NSMutableURLRequest	*request = [[[NSMutableURLRequest alloc] init] autorelease];
	[request setURL:mSubmitURL];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setValue:[NSString stringWithFormat:@"%d", [data length]] forHTTPHeaderField:@"Content-Length"];
	[request setHTTPBody:data];
	
	// Set action
	mAction = kSubmitAction;
	
	// Create connection
	NSURLConnection	*connection	= [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if(!connection)
	{
		[self notifyNetworkError];
		return;
	}
}

#pragma mark -

- (BSTrackQueue *)trackQueue
{
	return mTrackQueue;
}

- (void)setTrackQueue:(BSTrackQueue *)aTrackQueue
{
	// Prevent retain cycles
	mTrackQueue = aTrackQueue;
}

@end
