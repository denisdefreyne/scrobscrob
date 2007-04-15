//
//	BSTrackFilter.m
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import "BSTrackFilter.h"

#import "NSTimer+Pausing.h"


@interface BSTrackFilter (Private)

- (NSTimer *)timerHalf;
- (void)setTimerHalf:(NSTimer *)aTimerHalf;

- (NSTimer *)timer240;
- (void)setTimer240:(NSTimer *)aTimer240;

- (BSTrack *)currentTrack;
- (void)setCurrentTrack:(BSTrack *)aCurrentTrack;

#pragma mark -

- (void)trackPlayed:(BSTrack *)aTrack;
- (void)trackPaused;

#pragma mark -

- (void)timerFired:(NSTimer *)aTimer;

@end

#pragma mark -

@implementation BSTrackFilter (Private)

- (NSTimer *)timerHalf
{
	return mTimerHalf;
}

- (void)setTimerHalf:(NSTimer *)aTimerHalf
{
	if(mTimerHalf == aTimerHalf)
		return;
	
	[mTimerHalf invalidate];
	
	[mTimerHalf release];
	mTimerHalf = [aTimerHalf retain];
}

- (NSTimer *)timer240
{
	return mTimer240;
}

- (void)setTimer240:(NSTimer *)aTimer240
{
	if(mTimer240 == aTimer240)
		return;
	
	[mTimer240 invalidate];
	
	[mTimer240 release];
	mTimer240 = [aTimer240 retain];
}

- (BSTrack *)currentTrack
{
	return mCurrentTrack;
}

- (void)setCurrentTrack:(BSTrack *)aCurrentTrack
{
	if(mCurrentTrack == aCurrentTrack)
		return;
	
	[mCurrentTrack release];
	mCurrentTrack = [aCurrentTrack retain];
}

#pragma mark -

- (void)trackPlayed:(BSTrack *)aTrack
{
	// Get necessary track information
	int		totalTime	= [aTrack totalTime];
	
	// Resume the timers if the track was paused
	if([mCurrentTrack isEqual:aTrack])
	{
		[mTimerHalf resume];
		[mTimer240 resume];
		return;
	}
	
	// Ignore tracks which are shorter than 30 seconds
	if(totalTime < 30)
		return;
	
	// Save track
	[self setCurrentTrack:aTrack];
	
	// Set up both timers
	double halfTime = (double)totalTime/(double)2.0;
	[self setTimerHalf:[NSTimer scheduledTimerWithTimeInterval:halfTime target:self selector:@selector(timerFired:) userInfo:nil repeats:NO]];
	[self setTimer240:[NSTimer scheduledTimerWithTimeInterval:20. target:self selector:@selector(timerFired:) userInfo:nil repeats:NO]];
}

- (void)trackPaused
{
	// Pause the timers
	[mTimerHalf pause];
	[mTimer240 pause];
}

#pragma mark -

- (void)timerFired:(NSTimer *)aTimer
{
	// Remove timer half
	[mTimerHalf invalidate];
	[self setTimerHalf:nil];
	
	// Remove timer 240
	[mTimer240 invalidate];
	[self setTimer240:nil];
	
	// Submit the track
	if([mDelegate respondsToSelector:@selector(trackFiltered:)])
		[mDelegate performSelector:@selector(trackFiltered:) withObject:mCurrentTrack];
}

@end

#pragma mark -

@implementation BSTrackFilter

- (id)init
{
	if(self = [super init])
	{
		;
	}
	
	return self;
}

- (void)dealloc
{
	[self setTimerHalf:nil];
	[self setTimer240:nil];
	
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

@end
