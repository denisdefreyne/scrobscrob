//
//	BSTrackQueue.h
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "BSTrack.h"


// A track queue stores newly listened tracks and hands them off to the
// submitter as soon as possible.

@interface BSTrackQueue : NSObject {
	id				mDelegate;
	BOOL			mMaySubmit;
	BOOL			mIsPaused;
	NSMutableArray	*mQueuedTracks;
}

- (id)delegate;
- (void)setDelegate:(id)aDelegate;

#pragma mark -

- (void)pause;
- (void)resume;

@end
