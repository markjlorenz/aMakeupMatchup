//
//  DBDUIViewTools.h
//  UniversalCardUITest
//
//  Created by Mark Lorenz on 12/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kDBDUIViewToolsAddSubviewAnimationTime (0.3)

@interface UIView (DBDUIViewTools) 
-(void) setFrameWidthProportional:(CGFloat)width;
-(void) setFrameHeightProportional:(CGFloat)height;

- (void) setFrameWidth:(CGFloat)width;
- (void) setFrameHeight:(CGFloat)height;
- (void) setFrameOrigin:(CGPoint)point;
- (void) setFrameOriginX:(CGFloat)X;
- (void) setFrameOriginY:(CGFloat)Y;
- (void) setFrameFromSize:(CGSize)size;

- (void) setBoundsWidth:(CGFloat)width;
- (void) setBoundsHeight:(CGFloat)height;
- (void) setBoundsFromSize:(CGSize)size;

-(void) setCenterX:(CGFloat)X;
-(void) setCenterY:(CGFloat)Y;

-(CGSize) boundsSize;

-(void) addSubview:(UIView*)view animated:(BOOL)animated alpha:(CGFloat)alpha;
-(void) removeFromSuperviewAnimated:(BOOL)animated;
-(void)fadeInWithDelegate:(id)delegate;
-(void)fadeOutWithDelegate:(id)delegate;
@end
