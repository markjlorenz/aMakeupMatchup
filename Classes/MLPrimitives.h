//
//  MLPrimitives.h
//  itryiton
//
//  Created by Mark Lorenz on 10/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
// this is a convenience class to be used LIGHTLY if a few primitaves need to be used, say for a dictionary key

#import <Foundation/Foundation.h>
//#import "runtime.h"  //this seems need for copyWithZone: but that just doens't seem right.

@interface MLPrimitives : NSObject <NSCopying, NSCoding>{
	NSInteger nsInt;
	NSUInteger nsuInt;
	CGPoint point;
	CGSize size;
	CGRect rect;
	CGAffineTransform transform;
}

@property (nonatomic, assign) NSInteger nsInt;
@property (nonatomic, assign) NSUInteger nsuInt;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGRect rect;
@property (nonatomic, assign) CGAffineTransform transform;

- (id)copyWithZone:(NSZone *)zone;

-(void) NSLogCGPoint;
-(void) NSLogCGPoint:(CGPoint)point withMessage:(NSString*)message;
+(void) NSLogCGPoint:(CGPoint)point withMessage:(NSString*)message;
-(void) NSLogCGRect;
-(void) NSLogCGRect:(CGRect)rect withMessage:(NSString*)message;
+(void) NSLogCGRect:(CGRect)rect withMessage:(NSString*)message;

@end
