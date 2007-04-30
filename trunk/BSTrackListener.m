//
//	BSTrackListener.m
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import "BSTrackListener.h"

#import "BSTrack.h"


@implementation BSTrackListener

- (void)dealloc
{
	[self setTrackFilter:nil];
	
	[super dealloc];
}

#pragma mark -

- (void)start
{
	;
}

- (void)stop
{
	;
}

#pragma mark -

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

@end
