//
//	BSScrobbler.h
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import <Cocoa/Cocoa.h>


extern NSString *BSQueuePausedNotificationName;
extern NSString *BSQueueResumedNotificationName;

extern NSString *BSAuthenticationFailedNotificationName;
extern NSString *BSNetworkErrorReceivedNotificationName;

@class BSTrackListener, BSTrackFilter, BSTrackQueue, BSProtocolHandler;

@interface BSScrobbler : NSObject {
	BSTrackListener		*mTrackListener;
	BSTrackFilter		*mTrackFilter;
	BSTrackQueue		*mTrackQueue;
	BSProtocolHandler	*mProtocolHandler;
}

- (BOOL)isLoggedIn;
- (NSString *)username;
- (void)loginWithUsername:(NSString *)aUsername password:(NSString *)aPassword;

- (BOOL)isPaused;
- (void)startScrobbling;
- (void)stopScrobbling;

@end
