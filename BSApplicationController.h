//
//	BSApplicationController.h
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@class BSLoginWindowController;
@class BSScrobbler;

@interface BSApplicationController : NSObject {
	IBOutlet BSLoginWindowController	*mLoginWindowController;
	
	BSScrobbler							*mScrobbler;
	
	IBOutlet NSMenu						*mMenu;
	NSStatusItem						*mStatusItem;
}

- (void)updateMenu;

#pragma mark -

- (void)loginWithUsername:(NSString *)aUsername password:(NSString *)aPassword;

#pragma mark -

- (IBAction)toggleScrobbling:(id)sender;

- (IBAction)visitScrobScrobSite:(id)sender;

- (IBAction)viewLastFmDashboard:(id)sender;
- (IBAction)viewLastFmProfile:(id)sender;

@end
