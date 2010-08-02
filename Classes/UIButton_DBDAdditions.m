//
//  UIButton_DBDAdditions.m
//  itryiton
//
//  Created by Mark Lorenz on 2-Mar-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "UIButton_DBDAdditions.h"

@implementation UIButton (UIButton_DBDAdditions)

+ (id)customButtonWithType:(UIButtonType_DBDAddition)buttonType{
	return [UIButton glossyButtonWithColorForNormalState:UIButtonColorWhite andColorForHighlightedState:UIButtonColorBlue]; 
}

+ (id)glossyButtonWithColorForNormalState:(UIButtonColor_DBDAddition)normalButtonColor andColorForHighlightedState:(UIButtonColor_DBDAddition)highlightedButtonColor{
	UIButton *button = [self buttonWithType:UIButtonTypeCustom];
	NSString *normalButtonFilename = [button filenameFromColor:normalButtonColor];
	NSString *highlightedButtonFilename = [button filenameFromColor:highlightedButtonColor];
	UIImage *stretchableButtonImageNormal = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:normalButtonFilename ofType:@"png"]] stretchableImageWithLeftCapWidth:12 topCapHeight:0]; 
	[button setBackgroundImage:stretchableButtonImageNormal forState: UIControlStateNormal]; 
	UIImage *stretchableButtonImagePressed = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:highlightedButtonFilename ofType:@"png"]] stretchableImageWithLeftCapWidth:12 topCapHeight:0]; 
	[button setBackgroundImage:stretchableButtonImagePressed forState: UIControlStateHighlighted]; 	
	return button; 
	
}

-(void)applyGlossColor:(UIButtonColor_DBDAddition)color forState:(UIControlState*)state{
	UIImage *stretchableButtonImage = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[self filenameFromColor:color] ofType:@"png"]] stretchableImageWithLeftCapWidth:12 topCapHeight:0]; 
	[self setBackgroundImage:stretchableButtonImage forState:state];
}

-(NSString*)filenameFromColor:(UIButtonColor_DBDAddition)color{
	switch (color) {
		case UIButtonColorWhite:;
			return @"whiteButton";
			break;
		case UIButtonColorRed:;
			return @"redButton";
			break;
		case UIButtonColorGreen:;
			return @"greenButton";
			break;
		case UIButtonColorBlue:;
			return @"blueButton";
			break;
		case UIButtonColorPink:;
			return @"pinkButton";
			break;
			
		case UIButtonColorDarkWhite:;
			return @"darkWhiteButton";
			break;
		case UIButtonColorDarkRed:;
			return @"darkRedButton";
			break;
		case UIButtonColorDarkGreen:;
			return @"darkGreenButton";
			break;
		case UIButtonColorDarkBlue:;
			return @"darkBlueButton";
			break;
		case UIButtonColorDarkPink:;
			return @"darkPinkButton";
			break;
			
		default:;
			NSLog(@"Unknown Normal Button Color Sent To: %@", [NSString stringWithCString:object_getClassName(self)]);
			return nil;
			break;
	}
}

@end