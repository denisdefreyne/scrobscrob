//
//	BSApplicationController.h
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class BSLoginWindowController;
@class BSTrackListener, BSTrackFilter, BSTrackQueue, BSTrackSubmitter;

@interface BSApplicationController : NSObject {
	IBOutlet BSLoginWindowController	*mLoginWindowController;
	
	BSTrackListener						*mTrackListener;
	BSTrackFilter						*mTrackFilter;
	BSTrackQueue						*mTrackQueue;
	BSTrackSubmitter					*mTrackSubmitter;
	
	IBOutlet NSMenu						*mMenu;
	NSStatusItem						*mStatusItem;
}

- (void)updateMenu;

#pragma mark -

- (void)loginWithUsername:(NSString *)aUsername password:(NSString *)aPassword;

#pragma mark -

- (IBAction)toggleScrobbling:(id)sender;

@end
