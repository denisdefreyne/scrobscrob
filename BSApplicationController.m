//
//	BSApplicationController.m
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import "BSApplicationController.h"


@implementation BSApplicationController

- (id)init
{
	if(self = [super init])
	{
		// Create track listener
		[self setTrackListener:[[[BSITunesTrackListener alloc] init] autorelease]];
		[mTrackListener start];
		
		// Create track filter
		[self setTrackFilter:[[[BSTrackFilter alloc] init] autorelease]];
		[mTrackListener setDelegate:mTrackFilter];
		
		// Create track queue
		[self setTrackQueue:[[[BSTrackQueue alloc] init] autorelease]];
		[mTrackFilter setDelegate:mTrackQueue];
		
		// Create track submitter
		[self setTrackSubmitter:[[[BSTrackSubmitter alloc] init] autorelease]];
		[mTrackQueue setDelegate:mTrackSubmitter];
		[mTrackSubmitter setDelegate:mTrackQueue];
		
		// Create remote
		[self setRemote:[[[BSRemote alloc] init] autorelease]];
	}
	
	return self;
}

- (void)dealloc
{
	[mTrackListener stop];
	
	[self setTrackListener:nil];
	[self setTrackFilter:nil];
	[self setTrackSubmitter:nil];
	[self setRemote:nil];
	
	[super dealloc];
}

#pragma mark -

- (BSTrackListener *)trackListener
{
	return mTrackListener;
}

- (void)setTrackListener:(BSTrackListener *)aTrackListener
{
	if(mTrackListener == aTrackListener)
		return;
	
	[mTrackListener release];
	mTrackListener = [aTrackListener retain];
}

- (BSTrackFilter *)trackFilter
{
	return mTrackFilter;
}

- (void)setTrackFilter:(BSTrackFilter *)aTrackFilter
{
	if(mTrackFilter == aTrackFilter)
		return;
	
	[mTrackFilter release];
	mTrackFilter = [aTrackFilter retain];
}

- (BSTrackSubmitter *)trackSubmitter
{
	return mTrackSubmitter;
}

- (void)setTrackSubmitter:(BSTrackSubmitter *)aTrackSubmitter
{
	if(mTrackSubmitter == aTrackSubmitter)
		return;
	
	[mTrackSubmitter release];
	mTrackSubmitter = [aTrackSubmitter retain];
}

- (BSTrackQueue *)trackQueue
{
	return mTrackQueue;
}

- (void)setTrackQueue:(BSTrackQueue *)aTrackQueue
{
	if(mTrackQueue == aTrackQueue)
		return;
	
	[mTrackQueue release];
	mTrackQueue = [aTrackQueue retain];
}

- (BSRemote *)remote
{
	return mRemote;
}

- (void)setRemote:(BSRemote *)aRemote
{
	if(mRemote == aRemote)
		return;
	
	[mRemote release];
	mRemote = [aRemote retain];
}

#pragma mark -

- (IBAction)playOrPause:(id)sender
{
	[mRemote playOrPause];
}

- (IBAction)playPrev:(id)sender
{
	[mRemote playPrev];
}

- (IBAction)playNext:(id)sender
{
	[mRemote playNext];
}

- (IBAction)login:(id)sender
{
	[mTrackSubmitter loginWithUsername:[mUsernameField stringValue] password:[mPasswordField stringValue]];
}

@end
