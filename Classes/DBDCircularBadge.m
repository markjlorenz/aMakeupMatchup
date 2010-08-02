//
//  DBDCircularBadge.m
//  UniversalCardUITest
//
//  Created by Mark Lorenz on 12/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DBDCircularBadge.h"


@implementation DBDCircularBadge
@synthesize displayValue;

- (void)dealloc {
	[self removeObserver:self forKeyPath:@"displayValue"];
	[badgeImage release];
	
    [super dealloc];
}

-(id)initWithDisplayValue:(NSUInteger)value center:(CGPoint)center{
	badgeImage = [[UIImage imageNamed:@"RedBadge.png"] retain];
	[self initWithFrame:CGRectMake(center.x-badgeImage.size.width/2.0, center.y-badgeImage.size.height/2.0, badgeImage.size.width, badgeImage.size.height)];
	self.displayValue = value;
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		label = [[UILabel alloc] initWithFrame:self.bounds];
		[self addSubview:label];
		[label release];
		label.textAlignment = UITextAlignmentCenter;
		label.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		label.adjustsFontSizeToFitWidth = YES;
		label.numberOfLines = 1;
		NSArray *fontFamilies = [UIFont familyNames]; //all this work just to get a felt marker font?
		NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:6]];
		label.font = [UIFont fontWithName:[fontNames objectAtIndex:0] size:11.0];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		
		[self addObserver:self forKeyPath:@"displayValue" options:(NSKeyValueObservingOptionNew) context:NULL];
		self.backgroundColor = [UIColor clearColor];
		
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
	[label setText:[NSString stringWithFormat:@"%i", displayValue]];
}

- (void)drawRect:(CGRect)rect {
	[badgeImage drawInRect:rect];
}





@end
