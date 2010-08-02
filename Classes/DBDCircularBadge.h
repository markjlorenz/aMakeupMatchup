//
//  DBDCircularBadge.h
//  UniversalCardUITest
//
//  Created by Mark Lorenz on 12/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DBDCircularBadge : UIView {
	UILabel *label;
	NSUInteger displayValue;
	UIImage *badgeImage;
}
@property (nonatomic, assign) NSUInteger displayValue;

-(id)initWithDisplayValue:(NSUInteger)value center:(CGPoint)center;//designated initializer for this class
@end
