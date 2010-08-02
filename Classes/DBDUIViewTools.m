//
//  DBDUIViewTools.m
//  UniversalCardUITest
//
//  Created by Mark Lorenz on 12/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DBDUIViewTools.h"


@implementation UIView (DBDUIViewTools)

-(void) setFrameWidthProportional:(CGFloat)width{
	CGPoint center = self.center;
	CGFloat startingWidth = self.frame.size.width;
	CGFloat startingHeight = self.frame.size.height;
	CGFloat height = width * startingHeight / startingWidth;
	self.bounds = CGRectMake(0.0, 0.0, width, height);
	self.center = center;
}

-(void) setFrameHeightProportional:(CGFloat)height{
	CGPoint center = self.center;
	CGFloat startingWidth = self.frame.size.width;
	CGFloat startingHeight = self.frame.size.height;
	CGFloat width = height * startingWidth / startingHeight;
	self.bounds = CGRectMake(0.0, 0.0, width, height);
	self.center = center;
}

- (void) setFrameWidth:(CGFloat)width{
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}
- (void) setFrameHeight:(CGFloat)height{
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}
- (void) setFrameOrigin:(CGPoint)point{
	self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
}

- (void) setFrameOriginX:(CGFloat)X{
	self.frame = CGRectMake(X, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void) setFrameOriginY:(CGFloat)Y{
	self.frame = CGRectMake(self.frame.origin.x, Y, self.frame.size.width, self.frame.size.height);
}

- (void) setFrameFromSize:(CGSize)size{
	self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
}

- (void) setBoundsWidth:(CGFloat)width{
	self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, width, self.bounds.size.height);	
}
- (void) setBoundsHeight:(CGFloat)height{
	self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, height);	
}
- (void) setBoundsFromSize:(CGSize)size{
	self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, size.width, size.height);
}
-(void) setCenterX:(CGFloat)X{
	self.center = CGPointMake(X, self.center.y);
}
-(void) setCenterY:(CGFloat)Y{
	self.center = CGPointMake(self.center.x, Y);
}


-(CGSize) boundsSize{
	return CGSizeMake(self.bounds.size.width, self.bounds.size.height);
}

-(void) addSubview:(UIView*)view animated:(BOOL)animated alpha:(CGFloat)alpha{
	if(animated){
		view.alpha = 0.0;
		[self addSubview:view];
		
		[UIView beginAnimations:@"addSubviewAnimation" context:nil];
		[UIView setAnimationDuration:kDBDUIViewToolsAddSubviewAnimationTime];
		
		view.alpha = alpha;
		
		[UIView commitAnimations];
	}
	else
		[self addSubview:view];
}

-(void)fadeOutWithDelegate:(id)delegate{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:delegate];
	
		self.alpha = 0.0;

	[UIView commitAnimations];
}

-(void)fadeInWithDelegate:(id)delegate{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:delegate];
	
		self.alpha = 1.0;

	[UIView commitAnimations];
}


-(void) removeFromSuperviewAnimated:(BOOL)animated{
	if(animated){	
		[UIView beginAnimations:@"removeFromSuperviewAnimation" context:nil];
		[UIView setAnimationDuration:kDBDUIViewToolsAddSubviewAnimationTime];
		
		self.alpha = 0.0;
		
		[UIView commitAnimations];
		[NSTimer scheduledTimerWithTimeInterval:kDBDUIViewToolsAddSubviewAnimationTime target:self selector:@selector(removeFromSuperview) userInfo:nil repeats:NO];	
	}
	else
		[self removeFromSuperview];
}

@end
