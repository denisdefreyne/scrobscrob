//
//	BSApplicationController.m
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import "BSApplicationController.h"

#import "BSLoginWindowController.h"
#import "BSTrackListener.h"
#import "BSITunesTrackListener.h"
#import "BSTrackFilter.h"
#import "BSTrackQueue.h"
#import "BSTrackSubmitter.h"


@implementation BSApplicationController

- (id)init
{
	if(self = [super init])
	{
		// Create track listener
		mTrackListener = [[BSITunesTrackListener alloc] init];
		[mTrackListener start];
		
		// Create track filter
		mTrackFilter = [[BSTrackFilter alloc] init];
		[mTrackListener setTrackFilter:mTrackFilter];
		
		// Create track queue
		mTrackQueue = [[BSTrackQueue alloc] init];
		[mTrackFilter setTrackQueue:mTrackQueue];
		
		// Create track submitter
		mTrackSubmitter = [[BSTrackSubmitter alloc] init];;
		[mTrackQueue setTrackSubmitter:mTrackSubmitter];
		[mTrackSubmitter setTrackQueue:mTrackQueue];
		
		// Setup notifications
		[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queuePausedOrResumed:)
                                                     name:BSQueueResumedNotificationName
                                                   object:nil
		];
		[[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(queuePausedOrResumed:)
                                                     name:BSQueuePausedNotificationName
                                                   object:nil
		];
	}
	
	return self;
}

- (void)dealloc
{
	[mTrackListener stop];
	
	[mTrackListener release];
	[mTrackFilter release];
	[mTrackQueue release];
	[mTrackSubmitter release];
	
	[mMenu release];
	[mStatusItem release];
	
	[super dealloc];
}

- (void)awakeFromNib
{
	mStatusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
	[mStatusItem setTitle:@"ScrobScrob"];
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
	// TODO localize
	if([mTrackQueue isPaused])
		[[mMenu itemAtIndex:0] setTitle:@"Start Scrobbling"];
	else
		[[mMenu itemAtIndex:0] setTitle:@"Stop Scrobbling"];
}

#pragma mark -

- (void)loginWithUsername:(NSString *)aUsername password:(NSString *)aPassword
{
	[mTrackSubmitter loginWithUsername:aUsername password:aPassword];
}

#pragma mark -

- (IBAction)toggleScrobbling:(id)sender
{
	// Check whether we need to login first
	if(![mTrackSubmitter isLoggedIn])
	{
		[mLoginWindowController showWindow:self];
		[[mLoginWindowController window] center];
		[[mLoginWindowController window] makeKeyAndOrderFront:self];
		return;
	}
	
	if([mTrackQueue isPaused])
		[mTrackQueue resume];
	else
		[mTrackQueue pause];
}

@end
