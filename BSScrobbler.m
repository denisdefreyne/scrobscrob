//
//	BSScrobbler.m
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import "BSScrobbler.h"


#import "BSTrackListener.h"
#import "BSITunesTrackListener.h"
#import "BSTrackFilter.h"
#import "BSTrackQueue.h"
#import "BSTrackSubmitter.h"

@implementation BSScrobbler

- (id)init
{
	if([super init])
	{
		// Create track listener
		mTrackListener = [[BSITunesTrackListener alloc] init];
		[mTrackListener start];
		
		// Create track filter
		mTrackFilter = [[BSTrackFilter alloc] init];
		[mTrackListener setTrackFilter:mTrackFilter];
		
		// Create track queue
		mTrackQueue = [[BSTrackQueue alloc] init];
		[mTrackFilter setTrackQueue:mTrackQueue];
		
		// Create track submitter
		mProtocolHandler = [[BSProtocolHandler alloc] init];;
		[mTrackQueue setProtocolHandler:mProtocolHandler];
		[mProtocolHandler setTrackQueue:mTrackQueue];
	}
	
	return self;
}

- (void)dealloc
{
	[mTrackListener stop];
	
	[mTrackListener release];
	[mTrackFilter release];
	[mTrackQueue release];
	[mProtocolHandler release];
	
	[super dealloc];
}

#pragma mark -

- (BOOL)isLoggedIn
{
	return [mProtocolHandler isLoggedIn];
}

- (void)loginWithUsername:(NSString *)aUsername password:(NSString *)aPassword
{
	[mProtocolHandler loginWithUsername:aUsername password:aPassword];
}

- (BOOL)isPaused
{
	return [mTrackQueue isPaused];
}

- (void)startScrobbling
{
	// Check whether we need to login first
	if(![mProtocolHandler isLoggedIn])
		return;
	
	// Check whether we're already scrobbling
	if(![mTrackQueue isPaused])
		return;
	
	[mTrackQueue resume];
}

- (void)stopScrobbling
{
	// Check whether we're already scrobbling
	if([mTrackQueue isPaused])
		return;
	
	[mTrackQueue pause];
}

@end
