//
//  DBDTouchableOverlay.h
//  iTheeWed
//
//  Created by Mark Lorenz on 1-Mar-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#import <UIKit/UIKit.h>

#define ML_DEBUG(x) ;  // "ML_DEBUG(x) ;"  -sliences dealloc logging  "ML_DEBUG(x) (x)" activates dealloc logging

@protocol DBDTouchableOverlayDelegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@interface DBDTouchableOverlay : UIView {
	 NSObject <DBDTouchableOverlayDelegate> *_delegate;
}
@property (nonatomic, assign, getter=delegate, setter=setDelegate)  NSObject <DBDTouchableOverlayDelegate> *_delegate;

-(id) initWithFrame:(CGRect)frame delegate:(NSObject <DBDTouchableOverlayDelegate> *)delegate;
@end

/* -- Revision History --
 v0.0	1-Mar-2010	Change Points: New File
 
 */