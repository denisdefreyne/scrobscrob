//
//	BSApplicationController.m
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import "BSApplicationController.h"

#import "BSLoginWindowController.h"
#import "BSScrobbler.h"


@implementation BSApplicationController

- (id)init
{
	if(self = [super init])
	{
		// Create scrobbler
		mScrobbler = [[BSScrobbler alloc] init];
		
		// Setup notifications
		[[NSNotificationCenter defaultCenter]
			addObserver:self selector:@selector(queuePausedOrResumed:) name:BSQueueResumedNotificationName object:nil];
		[[NSNotificationCenter defaultCenter]
			addObserver:self selector:@selector(queuePausedOrResumed:) name:BSQueuePausedNotificationName object:nil];
	}
	
	return self;
}

- (void)dealloc
{
	[mScrobbler release];
	
	[mMenu release];
	[mStatusItem release];
	
	[super dealloc];
}

- (void)awakeFromNib
{
	mStatusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[mStatusItem setTitle:[NSString stringWithUTF8String:"\xE2\x99\xAC"]]; // ♬ = 0xE299AC (UTF-8)
	[mStatusItem setHighlightMode:YES];
	[mStatusItem setMenu:mMenu];
	
	[self updateMenu];
}

#pragma mark -

- (void)queuePausedOrResumed:(NSNotification *)aNotification
{
	[self updateMenu];
}

- (void)updateMenu
{
	if([mScrobbler isPaused])
		[[mMenu itemAtIndex:0] setTitle:NSLocalizedString(@"Start Scrobbling", @"start scrobbling menu item title")];
	else
		[[mMenu itemAtIndex:0] setTitle:NSLocalizedString(@"Stop Scrobbling", @"stop scrobbling menu item title")];
}

#pragma mark -

- (void)loginWithUsername:(NSString *)aUsername password:(NSString *)aPassword
{
	[mScrobbler loginWithUsername:aUsername password:aPassword];
}

#pragma mark -

- (IBAction)toggleScrobbling:(id)sender
{
	// Check whether we need to login first
	if(![mScrobbler isLoggedIn])
	{
		[mLoginWindowController showWindow:self];
		[[mLoginWindowController window] center];
		[[mLoginWindowController window] makeKeyAndOrderFront:self];
		return;
	}
	
	if([mScrobbler isPaused])
		[mScrobbler startScrobbling];
	else
		[mScrobbler stopScrobbling];
}

- (IBAction)visitScrobScrobSite:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://scrobscrob.stoneship.org/"]];
}

- (IBAction)viewLastFmDashboard:(id)sender
{
	[[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.last.fm/dashboard/"]];
}

- (IBAction)viewLastFmProfile:(id)sender
{
	;
}

@end
