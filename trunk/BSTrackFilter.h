//
//	BSTrackFilter.h
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import <Cocoa/Cocoa.h>

// A track filter listens for notifications of songs being played
// or paused, and decides whether to submit the song or not.

@class BSTrackQueue, BSTrack;

@interface BSTrackFilter : NSObject {
	NSTimer			*mTimerHalf;
	NSTimer			*mTimer240;
	
	BSTrack			*mCurrentTrack;
	
	BSTrackQueue	*mTrackQueue;
}

- (void)trackPlayed:(BSTrack *)aTrack;
- (void)trackPaused;

#pragma mark -

- (BSTrackQueue *)trackQueue;
- (void)setTrackQueue:(BSTrackQueue *)aTrackQueue;

@end
