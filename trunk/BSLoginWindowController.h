//
//	BSLoginWindowController.h
//	ScrobScrob
//
//	Created by Denis Defreyne on 12/04/2007.
//

#import <Cocoa/Cocoa.h>


@class BSApplicationController;

@interface BSLoginWindowController : NSWindowController {
	IBOutlet NSTextField				*mUsernameTextField;
	IBOutlet NSSecureTextField			*mPasswordTextField;
	
	IBOutlet BSApplicationController	*mApplicationController;
}

- (IBAction)cancel:(id)sender;
- (IBAction)login:(id)sender;

@end
