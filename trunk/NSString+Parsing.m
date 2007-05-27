//
//	NSString+Parsing.m
//	ScrobScrob
//
//	Created by Denis Defreyne on 12/04/2007.
//

#import "NSString+Parsing.h"


@implementation NSString (Parsing)

- (BOOL)beginsWith:(NSString *)aString
{
	if([self length] < [aString length])
		return NO;
	
	return ([[self substringToIndex:[aString length]] isEqualToString:aString]);
}

@end
