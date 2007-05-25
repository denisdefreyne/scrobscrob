//
//	BSProtocolHandler.h
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import <Cocoa/Cocoa.h>


// A track submitter logs in and submits tracks immediately.

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
}

- (void)loginWithUsername:(NSString *)aUsername password:(NSString *)aPassword;
- (void)submitTracks:(NSArray *)aTracks;

#pragma mark -

- (BOOL)isLoggedIn;

#pragma mark -

- (BSTrackQueue *)trackQueue;
- (void)setTrackQueue:(BSTrackQueue *)aTrackQueue;

@end
