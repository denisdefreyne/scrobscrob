//
//	BSTrackFilter.h
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "BSTrack.h"


// A track filter listens for notifications of songs being played
// or paused, and decides whether to submit the song or not.

@interface BSTrackFilter : NSObject {
	NSTimer	*mTimerHalf;
	NSTimer	*mTimer240;
	
	BSTrack	*mCurrentTrack;
	
	id		mDelegate;
}

- (id)delegate;
- (void)setDelegate:(id)aDelegate;

@end
