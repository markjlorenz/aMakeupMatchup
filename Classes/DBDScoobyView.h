//
//  DBDScoobyView.h
//  iTheeWed
//
//  Created by Mark Lorenz on 27-Mar-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#import <UIKit/UIKit.h>
#import "DBDScoobyScrollView.h"

#define kDBDScoobyViewSensitivity (10000.0)
#define ML_DEBUG(x) ;  // "ML_DEBUG(x) ;"  -sliences dealloc logging  "ML_DEBUG(x) (x)" activates dealloc logging

//@protocol DBDScoobyViewSubview
//
//-(CGFloat) depth; 
//
//@end

@interface DBDScoobyView : UIView <UIAccelerometerDelegate>{
	UIAcceleration *previousAcceleration;
	
	NSMutableDictionary *depths;
	NSMutableDictionary *motions;  //we must store the motion as a double.  Float is not percise enough
}

// for depth, a larger number is closer to the screen.  0, 1, 2, 3 are pretty decent choices.
- (void)addSubview:(UIView*)view withDepth:(CGFloat)depth;
- (void)insertSubview:(UIView*)view atIndex:(NSInteger)index withDepth:(CGFloat)depth;
- (void)scrollView:(DBDScoobyScrollView*)scrollView willRemoveSubview:(UIView *)subview;
-(void) setup;
-(void)beginScoobyScroll;
-(void)endScoobyScroll;
@end

/* -- Revision History --
 v0.0	27-Mar-2010	Change Points: New File
 
 */