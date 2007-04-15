//
//	BSTrackListener.h
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import <Cocoa/Cocoa.h>


// A track listener checks what iTunes is doing and immediately sends
// notifications when a song is played or paused.

@interface BSTrackListener : NSObject {
	id mDelegate;
}

- (void)start;
- (void)stop;

#pragma mark -

- (id)delegate;
- (void)setDelegate:(id)aDelegate;

@end
