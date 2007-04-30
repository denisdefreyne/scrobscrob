//
//	BSITunesTrackListener.m
//	ScrobScrob
//
//	Copyright 2007 Denis Defreyne. All rights reserved.
//

#import "BSITunesTrackListener.h"

#import "BSTrack.h"


NSString *kAlbumKey			= @"Album";
NSString *kArtistKey		= @"Artist";
NSString *kNameKey			= @"Name";
NSString *kPlayerStateKey	= @"Player State";
NSString *kTotalTimeKey		= @"Total Time";

NSString *kPlayerStatePlayingValue	= @"Playing";
NSString *kPlayerStatePausedValue	= @"Paused";

@implementation BSITunesTrackListener

- (void)start
{
	// Register
	[[NSDistributedNotificationCenter defaultCenter]
		addObserver:self
		selector:@selector(playerInfoReceived:)
		name:@"com.apple.iTunes.playerInfo"
		object:nil
	];
}

- (void)stop
{
	// Deregister
	[[NSDistributedNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -

- (void)playerInfoReceived:(NSNotification *)aNotification
{
	// Get track information
	NSDictionary *userInfo = [aNotification userInfo];
	
	// Check whether we've started playing
	NSString *playerState = [[aNotification userInfo] objectForKey:kPlayerStateKey];
	if(![playerState isEqualToString:kPlayerStatePlayingValue])
	{
		// Notify paused
		[mTrackFilter trackPaused];
	}
	else
	{
		// Get track details
		NSString *artist	= [userInfo objectForKey:kArtistKey];
		NSString *album		= [userInfo objectForKey:kAlbumKey];
		NSString *name		= [userInfo objectForKey:kNameKey];
		long long totalTime	= [[userInfo objectForKey:kTotalTimeKey] longLongValue]/1000;
		
		// Create track
		BSTrack *track = [[[BSTrack alloc] initWithArtist:artist name:name album:album totalTime:totalTime] autorelease];
		
		// Notify played
		[mTrackFilter trackPlayed:track];
	}
}

@end
