//
//	BSTrackQueue.h
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import <Cocoa/Cocoa.h>


// A track queue stores newly listened tracks and hands them off to the
// submitter as soon as possible.

@class BSTrackSubmitter, BSTrack;

@interface BSTrackQueue : NSObject {
	BSTrackSubmitter	*mTrackSubmitter;
	BOOL				mMaySubmit;
	BOOL				mIsPaused;
	NSMutableArray		*mQueuedTracks;
}

- (BSTrackSubmitter *)trackSubmitter;
- (void)setTrackSubmitter:(BSTrackSubmitter *)aTrackSubmitter;

#pragma mark -

- (void)trackFiltered:(BSTrack *)aTrack;

#pragma mark -

- (void)pause;
- (void)resume;

@end
