//
//	BSTrackQueue.h
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import <Cocoa/Cocoa.h>


// A track queue stores newly listened tracks and hands them off to the
// submitter as soon as possible.

extern NSString *BSQueuePausedNotificationName;
extern NSString *BSQueueResumedNotificationName;

@class BSProtocolHandler, BSTrack;

@interface BSTrackQueue : NSObject {
	BSProtocolHandler	*mProtocolHandler;
	BOOL				mMaySubmit;
	BOOL				mIsPaused;
	NSMutableArray		*mQueuedTracks;
}

- (BSProtocolHandler *)protocolHandler;
- (void)setProtocolHandler:(BSProtocolHandler *)aProtocolHandler;

#pragma mark -

- (void)trackFiltered:(BSTrack *)aTrack;
- (void)submitIntervalReceived:(NSNumber *)aInterval;

#pragma mark -

- (void)pause;
- (void)resume;

- (BOOL)isPaused;

@end
