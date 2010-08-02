//
//  MLAppTipBubbleView.h
//  itryiton
//
//  Created by Mark Lorenz on 10/2/09.
//  Copyright 2009 Black Box Technology. All rights reserved.
//
/*
	This class is meant to prove an attractive pop-up view to alert the use of how to use the app, or that some action occured on their behalf
	The goal is to provide as little annoyance/interference to the user as possible.

	Keeping with the design philosphy, this class is NOT instantiated like other UIView subclasses.  This class automatically adds itself to the superview
	So you will instantiate it like:
	[[MLAppTipBubbleView alloc] initWithText:@"This is a tip!  Buy this app, help the developer quit his day job! \n Double tap the left side hide this message.  \n You can hide all messages from the app info screen." 
				  superView:contentView type:MLAppTipBubbleBubbleType 
						     autoDismissTime:5];
 
 Legal:  This class is released to you under GPL.  Use it as you wish, share it, change it.  Just make sure to submit your changes back to Black Box Technology:
		  You can reach us at: MarkJLorenz@(botFooler)Black-Box-Technology.com or MarkJLorenz@(botFooler)gmail.com
*/

#import <UIKit/UIKit.h>
//#define ML_DEBUG(x) (x)  // flip this bit to do the error logging
#define ML_DEBUG(x) ; // flip this bit to silence
//ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));

	static NSMutableArray *visibleTips;

@interface MLAppTipTextView : UITextView <UITextViewDelegate> { //sub class to allow double taps in the text area.
}
@end

static NSString *tipsEnabled;  //ye' olde class variable.  It's all for one and one for all, as far as wether or not to show the tips

typedef enum MLAppTipBubbleType { //if you change this layout you need to update dismissAnimation
	MLAppTipBubbleTagType,
	MLAppTipBubbleLowerLeft,
	MLAppTipBubbleLowerRight,
	MLAppTipBubbleLowerRightDown,
	MLAppTipBubbleUpperRightUp,
	MLAppTipBubbleLowerLeftDown,
	MLAppTipBubbleUpperLeftUp	
} MLAppTipBubbleType;

@interface MLAppTipBubbleView : UIView {
	UIImageView *tipBubbleImageView;
	MLAppTipTextView *tipTextView;
	UIButton *xButton;
	
	MLAppTipBubbleType bubbleType;
	UIViewAnimationTransition dismissAnimationType;
	
	CGSize stretchCoordinates;
	
	NSTimer *lifeCycleTimer; //if the user scrolls the text view, a little time is added to this timer.
}

@property (nonatomic, retain) UIImageView *tipBubbleImageView;
@property (nonatomic, retain) MLAppTipTextView *tipTextView;
@property (nonatomic, retain) UIButton *xButton;
@property (nonatomic, assign) UIViewAnimationTransition dismissAnimationType;
@property (nonatomic, assign) NSTimer *lifeCycleTimer;  //this is needed so that the text view can talk to the timer.

-(id) initWithText:(NSString*)tipText superView:(UIView*)view type:(MLAppTipBubbleType)type autoDismissTime:(NSTimeInterval)time;

//custom getter/setters
-(void) setText:(NSString*)tipText;
-(NSString*) text;

+(BOOL) tipsEnabled;
+(void) setTipsEnabled:(BOOL)enabled;
+(NSArray*) activeAppTips;
@end



