//
//	BSApplicationController.h
//	BetterScrobbler
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "BSITunesTrackListener.h"
#import "BSTrackFilter.h"
#import "BSTrackQueue.h"
#import "BSTrackSubmitter.h"
#import "BSRemote.h"


@interface BSApplicationController : NSObject {
	BSTrackListener				*mTrackListener;
	BSTrackFilter				*mTrackFilter;
	BSTrackQueue				*mTrackQueue;
	BSTrackSubmitter			*mTrackSubmitter;
	BSRemote					*mRemote;
	
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

- (BSRemote *)remote;
- (void)setRemote:(BSRemote *)aRemote;

#pragma mark -

- (IBAction)playOrPause:(id)sender;
- (IBAction)playPrev:(id)sender;
- (IBAction)playNext:(id)sender;

- (IBAction)login:(id)sender;

@end
