//
//	BSApplicationController.h
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "BSITunesTrackListener.h"
#import "BSTrackFilter.h"
#import "BSTrackQueue.h"
#import "BSTrackSubmitter.h"


@interface BSApplicationController : NSObject {
	BSTrackListener				*mTrackListener;
	BSTrackFilter				*mTrackFilter;
	BSTrackQueue				*mTrackQueue;
	BSTrackSubmitter			*mTrackSubmitter;
	
	IBOutlet NSTextField		*mUsernameField;
	IBOutlet NSSecureTextField	*mPasswordField;
}

#pragma mark -

- (BSTrackListener *)trackListener;
- (void)setTrackListener:(BSTrackListener *)aTrackListener;
	
- (BSTrackFilter *)trackFilter;
- (void)setTrackFilter:(BSTrackFilter *)aTrackFilter;
	
- (BSTrackQueue *)trackQueue;
- (void)setTrackQueue:(BSTrackQueue *)aTrackQueue;

- (BSTrackSubmitter *)trackSubmitter;
- (void)setTrackSubmitter:(BSTrackSubmitter *)aTrackSubmitter;

#pragma mark -

- (IBAction)start:(id)sender;
- (IBAction)stop:(id)sender;

@end
