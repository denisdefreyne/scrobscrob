//
//	BSTrackListener.m
//	BetterScrobbler
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import "BSTrackListener.h"

#import "BSTrack.h"


@implementation BSTrackListener

- (void)start
{
	;
}

- (void)stop
{
	;
}

#pragma mark -

- (id)delegate
{
	return mDelegate;
}

- (void)setDelegate:(id)aDelegate
{
	mDelegate = aDelegate;
}

@end
