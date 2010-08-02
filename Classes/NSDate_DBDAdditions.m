//
//  NSDate_iTWAdditions.h
//  iTheeWed
//
//  Created by Mark Lorenz on 2/21/10.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "NSDate_DBDAdditions.h"

@implementation NSDate (NSDate_DBDAdditions)

+(NSString*) serializedDateString{
	return [[NSNumber numberWithDouble:[NSDate timeIntervalSinceReferenceDate]] stringValue];
}

+ (NSString *)dateDifferenceStringFromString:(NSString *)dateString withFormat:(NSString *)dateFormat{
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
	[dateFormatter setDateFormat:dateFormat];
	NSDate *date = [dateFormatter dateFromString:dateString];
	[dateFormatter release];
	NSDate *now = [NSDate date];
	double time = [date timeIntervalSinceDate:now];
	time *= -1;
	if(time < 1) {
		return dateString;
	} else if (time < 60) {
		return NSLocalizedString(@"less than a minute ago", @"localized date");
	} else if (time < 3600) {
		int diff = round(time / 60);
		if (diff == 1) 
			return [NSString stringWithFormat:@"1 %@", NSLocalizedString(@"minute ago", @"localized date")];
		return [NSString stringWithFormat:@"%d %@", diff, NSLocalizedString(@"minutes ago", @"localized date")];
	} else if (time < 86400) {
		int diff = round(time / 60 / 60);
		if (diff == 1)
			return NSLocalizedString(@"1 hour ago", @"localized date");
		return [NSString stringWithFormat:@"%d %@", diff, NSLocalizedString(@"hours ago", @"localized date")];
	} else if (time < 604800) {
		int diff = round(time / 60 / 60 / 24);
		if (diff == 1) 
			return NSLocalizedString(@"yesterday", @"localized date");
		if (diff == 7) 
			return NSLocalizedString(@"last week", @"localized date");
		return[NSString stringWithFormat:@"%d %@", diff, NSLocalizedString(@"days ago", @"localized date")];
	} else {
		int diff = round(time / 60 / 60 / 24 / 7);
		if (diff == 1)
			return NSLocalizedString(@"last week", @"localized date");
		return [NSString stringWithFormat:@"%d %@", diff, NSLocalizedString(@"weeks ago", @"localized date")];
	}   
}

@end