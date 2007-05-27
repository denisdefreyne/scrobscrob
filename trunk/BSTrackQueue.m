//
//	BSTrackQueue.m
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import "BSTrackQueue.h"

#import "BSProtocolHandler.h"
#import "BSTrack.h"


NSString *BSQueuePausedNotificationName		= @"BS QueuePaused Notification";
NSString *BSQueueResumedNotificationName	= @"BS QueueResumed Notification";

@implementation BSTrackQueue

- (id)init
{
	if(self = [super init])
	{
		mMaySubmit = NO;
		mIsPaused = YES;
		mQueuedTracks = [[NSMutableArray alloc] init];
	}
	
	return self;
}

- (void)dealloc
{
	[self setProtocolHandler:nil];
	
	[mQueuedTracks release];
	
	[super dealloc];
}

#pragma mark -

- (void)readyForSubmitting:(NSTimer *)aTimer
{
	NSLog(@"Ready for submitting.");
	
	// Allow submitting
	mMaySubmit = YES;
	
	// Submit queued tracks
	[self queueOrSubmitTracks:mQueuedTracks];
}

- (void)trackFiltered:(BSTrack *)aTrack
{
	[self queueOrSubmitTracks:[NSArray arrayWithObject:aTrack]];
}

- (void)submitIntervalReceived:(NSNumber *)aTimeInterval
{
	NSLog(@"[TQ] Submitting again in %d seconds", [aTimeInterval doubleValue]);
	
	// Allow updates on given date
	[NSTimer scheduledTimerWithTimeInterval:[aTimeInterval doubleValue] target:self selector:@selector(readyForSubmitting:) userInfo:nil repeats:NO];
}

#pragma mark -

- (void)queueTracks:(NSArray *)aTracks
{
	NSLog(@"[TQ] Queueing %@", aTracks);
	
	[mQueuedTracks addObjectsFromArray:aTracks];
	
	NSLog(@"[TQ] Queued tracks: %@", mQueuedTracks);
}

- (void)submitTracks:(NSArray *)aTracks
{
	if([aTracks count] < 1)
		return;
	
	NSLog(@"[TQ] Submitting %@", aTracks);
	
	// Submit tracks
	[mProtocolHandler submitTracks:aTracks];
	
	// Dequeue tracks
	[mQueuedTracks removeObjectsInArray:aTracks];
	
	// Disallow submitting
	mMaySubmit = NO;
}

- (void)queueOrSubmitTracks:(NSArray *)aTracks
{
	if(mMaySubmit && !mIsPaused)
		[self submitTracks:aTracks];
	else
		[self queueTracks:aTracks];
}

#pragma mark -

- (void)pause
{
	NSLog(@"[TQ] Pausing.");
	
	mIsPaused = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName:BSQueuePausedNotificationName object:nil];
}

- (void)resume
{
	NSLog(@"[TQ] Resuming.");
	
	mIsPaused = NO;
	[[NSNotificationCenter defaultCenter] postNotificationName:BSQueueResumedNotificationName object:nil];
	
	// Submit queued tracks
	[self submitTracks:mQueuedTracks];
}

- (BOOL)isPaused
{
	return mIsPaused;
}

#pragma mark -

- (BSProtocolHandler *)protocolHandler
{
	return mProtocolHandler;
}

- (void)setProtocolHandler:(BSProtocolHandler *)aProtocolHandler
{
	if(mProtocolHandler == aProtocolHandler)
		return;
	
	[mProtocolHandler release];
	mProtocolHandler = [aProtocolHandler retain];
}

@end
