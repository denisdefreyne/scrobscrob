//
//	BSProtocolHandler.h
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import <Cocoa/Cocoa.h>


// A protocol handler logs in and submits tracks

extern NSString *BSUserAuthenticationFailedNotificationName;
extern NSString *BSPasswordAuthenticationFailedNotificationName;
extern NSString *BSNetworkErrorReceivedNotificationName;

@class BSTrackQueue, BSTrack;

@interface BSProtocolHandler : NSObject {
	NSMutableData	*mData;
	BSTrackQueue	*mTrackQueue;
	BOOL			mIsLoggedIn;
	NSString		*mAction;
	NSString		*mUsername;
	NSString		*mSingleHashedPassword;
	NSString		*mDoubleHashedPassword;
	NSURL			*mSubmitURL;
	NSMutableArray	*mTracks;
}

- (void)loginWithUsername:(NSString *)aUsername password:(NSString *)aPassword;
- (void)submitTracks:(NSArray *)aTracks;

#pragma mark -

- (BOOL)isLoggedIn;
- (NSString *)username;

#pragma mark -

- (BSTrackQueue *)trackQueue;
- (void)setTrackQueue:(BSTrackQueue *)aTrackQueue;

@end
