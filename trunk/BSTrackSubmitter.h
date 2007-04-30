//
//	BSTrackSubmitter.h
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "BSTrack.h"
#import "BSTrackFilter.h"


@interface BSTrackSubmitter : NSObject {
	NSMutableData	*mData;
	id				mDelegate;
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

- (id)delegate;
- (void)setDelegate:(id)aDelegate;

@end
