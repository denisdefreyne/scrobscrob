//
//  BSTrack.h
//  ScrobScrob
//
//  Created by Denis Defreyne on 12/04/2007.
//  Copyright 2007 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


extern NSString *kTrackKey;

// A track is simply a representation of a track in iTunes.

@interface BSTrack : NSObject {
	NSString		*mArtist;
	NSString		*mName;
	NSString		*mAlbum;
	int				mTotalTime;
	NSCalendarDate	*mDate;
}

- (id)initWithArtist:(NSString *)aArtist name:(NSString *)aName album:(NSString *)aAlbum totalTime:(int)aTotalTime;

#pragma mark -

- (NSString *)artist;
- (void)setArtist:(NSString *)aArtist;

- (NSString *)name;
- (void)setName:(NSString *)aName;

- (NSString *)album;
- (void)setAlbum:(NSString *)aAlbum;

- (int)totalTime;
- (void)setTotalTime:(int)aTotalTime;

- (NSCalendarDate *)date;
- (void)setDate:(NSCalendarDate *)aDate;

#pragma mark -

- (BOOL)isEqual:(BSTrack *)aOther;

@end
