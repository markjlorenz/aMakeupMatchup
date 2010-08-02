//
//  UIButton_DBDAdditions.h
//  itryiton
//
//  Created by Mark Lorenz on 2-Mar-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#import <Foundation/Foundation.h>

typedef enum UIButtonType_DBDAddition{
	UIButtonTypeGlossy,
}UIButtonType_DBDAddition;

typedef enum UIButtonColor_DBDAddition {
	UIButtonColorWhite,
	UIButtonColorRed,
	UIButtonColorGreen,
	UIButtonColorBlue,
	UIButtonColorPink,
	
	UIButtonColorDarkWhite,
	UIButtonColorDarkRed,
	UIButtonColorDarkGreen,
	UIButtonColorDarkBlue,
	UIButtonColorDarkPink
} UIButtonColor_DBDAddition;
	
@interface  UIButton (UIButton_DBDAdditions)
+ (id)customButtonWithType:(UIButtonType_DBDAddition)buttonType;
+ (id)glossyButtonWithColorForNormalState:(UIButtonColor_DBDAddition)normalButtonColor andColorForHighlightedState:(UIButtonColor_DBDAddition)highlightedButtonColor;

-(void)applyGlossColor:(UIButtonColor_DBDAddition)color forState:(UIControlState*)state;

@end

/* -- Revision History --
 v0.0	2-Mar-2010	Change Points: New File
 
*/
