//
//	BSRemote.m
//	ScrobScrob
//
//	Created by Denis Defreyne on 12/04/2007.
//

#import "BSRemote.h"


@implementation BSRemote

- (void)playOrPause
{
	static NSAppleScript *appleScript = nil;
	
	// Create and compile script if it isn't already
	if(!appleScript)
	{
		appleScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nplaypause\nend tell"];
		[appleScript compileAndReturnError:nil];
	}
	
	[appleScript executeAndReturnError:nil];
}

- (void)playPrev
{
	static NSAppleScript *appleScript = nil;
	
	// Create and compile script if it isn't already
	if(!appleScript)
	{
		appleScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nprevious track\nend tell"];
		[appleScript compileAndReturnError:nil];
	}
	
	[appleScript executeAndReturnError:nil];
}

- (void)playNext
{
	static NSAppleScript *appleScript = nil;
	
	// Create and compile script if it isn't already
	if(!appleScript)
	{
		appleScript = [[NSAppleScript alloc] initWithSource:@"tell application \"iTunes\"\nnext track\nend tell"];
		[appleScript compileAndReturnError:nil];
	}
	
	[appleScript executeAndReturnError:nil];
}

@end
