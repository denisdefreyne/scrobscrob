//
//	BSTrackQueue.m
//	BetterScrobbler
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import "BSTrackQueue.h"


@interface BSTrackQueue (Private)

- (void)trackFiltered:(BSTrack *)aTrack;
- (void)submitIntervalReceived:(NSNumber *)aInterval;

#pragma mark -

- (void)queueTrack:(BSTrack *)aTrack;
- (void)submitTracks:(NSArray *)aTracks;

@end

@implementation BSTrackQueue (Private)

- (void)trackFiltered:(BSTrack *)aTrack
{
	// Queue or submit track
	if(mMaySubmit)
		[self submitTracks:[NSArray arrayWithObject:aTrack]];
	else
		[self queueTrack:aTrack];
}

- (void)submitIntervalReceived:(NSNumber *)aTimeInterval
{
	// Allow updates on given date
	[NSTimer scheduledTimerWithTimeInterval:[aTimeInterval doubleValue] target:self selector:@selector(readyForSubmitting:) userInfo:nil repeats:NO];
}

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
	if([mDelegate respondsToSelector:@selector(submitTracks:)])
		[mDelegate performSelector:@selector(submitTracks:) withObject:aTracks];
	
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
		[self setQueuedTracks:[[[NSMutableArray alloc] init] autorelease]];
	}
	
	return self;
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

@end
