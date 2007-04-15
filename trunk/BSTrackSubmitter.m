//
//	BSTrackSubmitter.m
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import "BSTrackSubmitter.h"

#import "CocoaCryptoHashing.h"


NSString *kClientID			= @"tst";
NSString *kClientVersion	= @"1.0";

NSString *kHandshakeAction	= @"BS Handshake Action";
NSString *kSubmitAction		= @"BS Submit Action";

@interface BSTrackSubmitter (Private)

- (NSMutableData *)data;
- (void)setData:(NSMutableData *)aData;

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

#pragma mark -

@implementation BSTrackSubmitter (Private)

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
	NSString *string = [NSString stringWithCString:[mData bytes] encoding:NSUTF8StringEncoding];
	
	// Check action
	if(mAction == kHandshakeAction)
		[self handleHandshakeResponse:string];
	else if(mAction == kSubmitAction)
		[self handleSubmitResponse:string];
	else
		NSLog(@"!!! ERROR: Unknown action.");
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)aError
{
	NSLog(@"!!! ERROR: %@ %@", [aError localizedDescription], [[aError userInfo] objectForKey:NSErrorFailingURLStringKey]);
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
// FAILED <reason>
// INTERVAL <n>
// --------------------
// BADUSER <reason>
// INTERVAL <n>
// --------------------

- (void)handleHandshakeResponse:(NSString *)aResponse
{
	// Split string and do a small check
	NSArray *components = [aResponse componentsSeparatedByString:@"\n"];
	if([components count] != 5 && [components count] != 3)
	{
		NSLog(@"!!! ERROR: Malformatted handshake response: %@", aResponse);
		return;
	}
	
	// TODO Check whether we have an error condition
	if([components count] == 2)
	{
		NSLog(@"!!! WARNING: Error condition: %@", aResponse);
		return;
	}
	
	// TODO Check whether the format is in the correct format
	;
	
	// Extract MD5 challenge, URL to submit script, and interval
	NSString	*md5Challenge	= [components objectAtIndex:1];
	NSURL		*submitURL		= [NSURL URLWithString:[components objectAtIndex:2]];
	double		interval		= (double)[[[components objectAtIndex:3] substringFromIndex:9] intValue];
	
	// Store what's necessary
	[self setDoubleHashedPassword:[[NSString stringWithFormat:@"%@%@", mSingleHashedPassword, md5Challenge] md5HexHash]];
	[self setSubmitURL:submitURL];
	
	// Notify track queue
	if([mDelegate respondsToSelector:@selector(submitIntervalReceived:)])
		[mDelegate performSelector:@selector(submitIntervalReceived:) withObject:[NSNumber numberWithDouble:interval]];
}

- (void)handleSubmitResponse:(NSString *)aResponse
{
	;
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

@implementation BSTrackSubmitter

- (void)dealloc
{
	[self setData:nil];
	
	[super dealloc];
}

#pragma mark -

- (id)delegate
{
	return mDelegate;
}

- (void)setDelegate:(id)aDelegate
{
	mDelegate = aDelegate;
}

#pragma mark -

- (void)loginWithUsername:(NSString *)aUsername password:(NSString *)aPassword
{
	// Create request
	NSString		*urlString	= [NSString stringWithFormat:@"http://post.audioscrobbler.com/?hs=true&p=1.1&c=%@&v=%@&u=%@", kClientID, kClientVersion, aUsername];
	NSURLRequest	*request	= [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	
	NSLog(@"Logging in.");
	
	// Set action
	mAction = kHandshakeAction;
	
	// Store username and password
	[self setUsername:aUsername];
	[self setSingleHashedPassword:[aPassword md5HexHash]];
	
	// Create connection
	NSURLConnection	*connection	= [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if(!connection)
	{
		// Error!
		NSLog(@"!!! ERROR: could not create connection");
		return;
	}
}

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

- (void)submitTracks:(NSArray *)aTracks
{
	NSLog(@"Submitting tracks: %@", aTracks);
	
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
		// Error!
		NSLog(@"!!! ERROR: could not create connection");
		return;
	}
}

@end
