//
//  DBDMovableView.h
//  UniversalCardUITest
//
//  Created by Mark Lorenz on 12/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
// Notes on subclassing:  If you subclass, you can override the touches: methods if you call super.  The thing you do before your
// call to super will occur before the things DBDMovableView needs to do to move the view around.

#import <UIKit/UIKit.h>
#define DBDMovableViewHoldTime (1.0)

@class DBDMovableView;
@protocol DBDMovableViewObserver

-(void) touchesBegan:(NSSet*)touches forMovableView:(DBDMovableView*)view event:(UIEvent*)event;
-(void) touchesMoved:(NSSet*)touches forMovableView:(DBDMovableView*)view event:(UIEvent*)event;
-(void) touchesEnded:(NSSet*)touches forMovableView:(DBDMovableView*)view event:(UIEvent*)event;
-(void) touchesCancelled:(NSSet*)touches forMovableView:(DBDMovableView*)view event:(UIEvent*)event;
-(void) touchesHeld:(NSSet*)touches forMovableView:(DBDMovableView*)view event:(UIEvent*)event;

-(void) movableView:(DBDMovableView*)view didMoveCenterTo:(CGPoint)point inView:(UIView*)inView;

@end

@interface DBDMovableView : UIView {
	NSTimer *touchHoldTimer;
	BOOL touchCurrentlyHeld;
	BOOL allowObjectMove;
	CGSize touchOffsetFromCenter;
	UIImage *_image;
	NSMutableSet *observers;
}
@property (nonatomic, readonly) NSMutableSet *observers;
@property (nonatomic, retain, getter=image, setter=setImage) UIImage *_image;
@property (nonatomic, assign) BOOL allowObjectMove;
@property (nonatomic, readonly) BOOL touchCurrentlyHeld;

-(void) registerObserver:(id <DBDMovableViewObserver>)regsitrant;
-(void) deregisterObserver:(id <DBDMovableViewObserver>)regsitrant;
- (id)initWithImage:(UIImage*)image;
@end


@interface DBDMovableView (DBDMovableView_hidden)
-(void)touchTimerHelper:(NSTimer*)timer;
-(void)touchesHeld:(NSSet*)touches forEvent:(UIEvent*)event;

@end