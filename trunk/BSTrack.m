//
//  BSTrack.m
//  ScrobScrob
//
//  Created by Denis Defreyne on 12/04/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import "BSTrack.h"


NSString *kTrackKey = @"BS Track Key";

@implementation BSTrack

- (id)init
{
	if(self = [super init])
	{
		;
	}
	
	return self;
}

- (id)initWithArtist:(NSString *)aArtist name:(NSString *)aName album:(NSString *)aAlbum totalTime:(int)aTotalTime
{
	if(self = [super init])
	{
		[self setArtist:aArtist];
		[self setName:aName];
		[self setAlbum:aAlbum];
		[self setTotalTime:aTotalTime];
		[self setDate:[NSCalendarDate calendarDate]];
		[mDate setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	}
	
	return self;
}

- (void)dealloc
{
	[self setArtist:nil];
	
	[super dealloc];
}

#pragma mark -

- (NSString *)description
{
	return [NSString stringWithFormat:@"'%@' by '%@' from the '%@' album (%i:%i)", mName, mArtist, mAlbum, mTotalTime/60, mTotalTime%60];
}

#pragma mark

- (NSString *)artist
{
	return mArtist;
}

- (void)setArtist:(NSString *)aArtist
{
	if(mArtist == aArtist)
		return;
	
	[mArtist release];
	mArtist = [aArtist retain];
}

- (NSString *)name
{
	return mName;
}

- (void)setName:(NSString *)aName
{
	if(mName == aName)
		return;
	
	[mName release];
	mName = [aName retain];
}

- (NSString *)album
{
	return mAlbum;
}

- (void)setAlbum:(NSString *)aAlbum
{
	if(mAlbum == aAlbum)
		return;
	
	[mAlbum release];
	mAlbum = [aAlbum retain];
}

- (int)totalTime
{
	return mTotalTime;
}

- (void)setTotalTime:(int)aTotalTime
{
	mTotalTime = aTotalTime;
}

- (NSCalendarDate *)date
{
	return mDate;
}

- (void)setDate:(NSCalendarDate *)aDate
{
	if(mDate == aDate)
		return;
	
	[mDate release];
	mDate = [aDate retain];
}

#pragma mark -

- (BOOL)isEqual:(BSTrack *)aOther
{
	if(![[self artist] isEqualToString:[aOther artist]])
		return NO;
	
	if(![[self name] isEqualToString:[aOther name]])
		return NO;
	
	if(![[self album] isEqualToString:[aOther album]])
		return NO;
	
	if([self totalTime] != [aOther totalTime])
		return NO;
	
	return YES;
}

@end
