//
//	BSTrackQueue.m
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import "BSTrackQueue.h"

#import "BSTrackSubmitter.h"
#import "BSTrack.h"


NSString *BSQueuePausedNotificationName		= @"BS QueuePaused Notification";
NSString *BSQueueResumedNotificationName	= @"BS QueueResumed Notification";

@interface BSTrackQueue (Private)

- (void)queueTrack:(BSTrack *)aTrack;
- (void)submitTracks:(NSArray *)aTracks;

@end

@implementation BSTrackQueue (Private)

- (void)readyForSubmitting:(NSTimer *)aTimer
{
	NSLog(@"Ready for submitting.");
	
	// Allow submitting
	mMaySubmit = YES;
	
	// Submit queued tracks
	[self submitTracks:mQueuedTracks];
}

#pragma mark -

- (void)queueTrack:(BSTrack *)aTrack
{
	NSLog(@"Queueing track (%@)", aTrack);
	
	[mQueuedTracks addObject:aTrack];
}

- (void)submitTracks:(NSArray *)aTracks
{
	if([aTracks count] < 1)
		return;
	
	// Submit tracks
	[mProtocolHandler submitTracks:aTracks];
	
	// Disallow submitting
	mMaySubmit = NO;
}

#pragma mark -

- (NSMutableArray *)queuedTracks
{
	return mQueuedTracks;
}

- (void)setQueuedTracks:(NSMutableArray *)aQueuedTracks
{
	if(mQueuedTracks == aQueuedTracks)
		return;
	
	[mQueuedTracks release];
	mQueuedTracks = [aQueuedTracks retain];
}

@end

#pragma mark -

@implementation BSTrackQueue

- (id)init
{
	if(self = [super init])
	{
		mMaySubmit = NO;
		mIsPaused = YES;
		[self setQueuedTracks:[[[NSMutableArray alloc] init] autorelease]];
	}
	
	return self;
}

- (void)dealloc
{
	[self setProtocolHandler:nil];
	
	[super dealloc];
}

#pragma mark -

- (void)trackFiltered:(BSTrack *)aTrack
{
	// Queue or submit track
	if(mMaySubmit && !mIsPaused)
		[self submitTracks:[NSArray arrayWithObject:aTrack]];
	else
		[self queueTrack:aTrack];
}

- (void)submitIntervalReceived:(NSNumber *)aTimeInterval
{
	// Allow updates on given date
	[NSTimer scheduledTimerWithTimeInterval:[aTimeInterval doubleValue] target:self selector:@selector(readyForSubmitting:) userInfo:nil repeats:NO];
}

#pragma mark -

- (void)pause
{
	NSLog(@"Pausing.");
	
	mIsPaused = YES;
	[[NSNotificationCenter defaultCenter] postNotificationName:BSQueuePausedNotificationName object:nil];
}

- (void)resume
{
	NSLog(@"Resuming.");
	
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
