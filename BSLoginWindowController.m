//
//	BSLoginWindowController.m
//	ScrobScrob
//
//	Created by Denis Defreyne on 12/04/2007.
//

#import "BSLoginWindowController.h"

#import "BSApplicationController.h"


@implementation BSLoginWindowController

- (id)init
{
	if([super initWithWindowNibName:@"LoginWindow"])
	{
		;
	}
	
	return self;
}

#pragma mark -

- (IBAction)cancel:(id)sender
{
	[self close];
}

- (IBAction)login:(id)sender
{
	[mApplicationController loginWithUsername:[mUsernameTextField stringValue] password:[mPasswordTextField stringValue]];
	
	[self close];
}

@end
