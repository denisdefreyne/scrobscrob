//
//	BSScrobbler.h
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import <Cocoa/Cocoa.h>


extern NSString *BSQueuePausedNotificationName;
extern NSString *BSQueueResumedNotificationName;

@class BSTrackListener, BSTrackFilter, BSTrackQueue, BSTrackSubmitter;

@interface BSScrobbler : NSObject {
	BSTrackListener		*mTrackListener;
	BSTrackFilter		*mTrackFilter;
	BSTrackQueue		*mTrackQueue;
	BSTrackSubmitter	*mTrackSubmitter;
}

- (BOOL)isLoggedIn;
- (void)loginWithUsername:(NSString *)aUsername password:(NSString *)aPassword;

- (BOOL)isPaused;
- (void)startScrobbling;
- (void)stopScrobbling;

@end