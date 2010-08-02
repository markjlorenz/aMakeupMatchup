//
//  MLPrimitives.m
//  itryiton
//
//  Created by Mark Lorenz on 10/16/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MLPrimitives.h"

@implementation MLPrimitives
@synthesize nsInt;
@synthesize nsuInt;
@synthesize point;
@synthesize size;
@synthesize rect;
@synthesize transform;

/*
- (id)copyWithZone:(NSZone *)zone{
	//I'm not smart enough to know what to do with zone.
	NSLog(@"you just ran copyWithZone: on an MLPrimitive  you need to step though the method to make sure that it's working.  It's unchecked.");
	
	//put all the property names in to an array, propertyNames
	NSMutableArray *propertyNames = [[NSMutableArray alloc] init];
	unsigned int outCount;
	objc_property_t *propertyList  = class_copyPropertyList([self class], &outCount);
	
	for (NSUInteger i = 0; i < outCount; i++){
		NSString *property = [NSString stringWithCString:property_getName(propertyList[i])];
		[propertyNames addObject:property];
	}
	
	MLPrimitives *copyOfSelf = [[MLPrimitives alloc] init];
	for (NSString *key in propertyNames){
		[copyOfSelf setValue:[self valueForKey:key forKey:key]];
	}
	
	free(propertyList);
	[propertyNames release];
	
	NSLog(@"copy that shit");
	return copyOfSelf;
}  */

-(void) NSLogCGPoint{[self NSLogCGPoint:point withMessage:nil];}
-(void) NSLogCGPoint:(CGPoint)point withMessage:(NSString*)message{NSLog(@"\n %@ x: %f \n %@ y: %f", message, point.x, message, point.y);}
+(void) NSLogCGPoint:(CGPoint)point withMessage:(NSString*)message{NSLog(@"\n %@ x: %f , %@ y: %f \n ", message, point.x, message, point.y);} 
-(void) NSLogCGRect{[self NSLogCGRect:rect withMessage:nil];}
-(void) NSLogCGRect:(CGRect)rect withMessage:(NSString*)message{NSLog(@"\n %@ x: %f \n %@ y: %f \n %@ width: %f \n %@ height: %f", message, rect.origin.x, message, rect.origin.y, message, rect.size.width, message, rect.size.height);}
+(void) NSLogCGRect:(CGRect)rect withMessage:(NSString*)message{NSLog(@"\n %@ x: %f \n %@ y: %f \n %@ width: %f \n %@ height: %f", message, rect.origin.x, message, rect.origin.y, message, rect.size.width, message, rect.size.height);} 

- (void) encodeWithCoder:(NSCoder*)encoder{
    [encoder encodeDouble:point.x forKey:@"pointX"];
    [encoder encodeDouble:point.y forKey:@"pointY"];
	
	[encoder encodeDouble:rect.origin.x forKey:@"rectOriginX"];
	[encoder encodeDouble:rect.origin.y forKey:@"rectOriginY"];
	[encoder encodeDouble:rect.size.width forKey:@"rectWidth"];
	[encoder encodeDouble:rect.size.height forKey:@"rectHeight"];
	
	[encoder encodeDouble:transform.a forKey:@"transformA"];
	[encoder encodeDouble:transform.b forKey:@"transformB"];
	[encoder encodeDouble:transform.c forKey:@"transformC"];
	[encoder encodeDouble:transform.d forKey:@"transformD"];
	[encoder encodeDouble:transform.tx forKey:@"transformTX"];
	[encoder encodeDouble:transform.ty forKey:@"transformTY"];
	
}
- (id) initWithCoder:(NSCoder*)decoder{
	double pointX = [decoder decodeDoubleForKey:@"pointX"];
	double pointY = [decoder decodeDoubleForKey:@"pointY"];
	point = CGPointMake(pointX, pointY);
	
	double rectOriginX = [decoder decodeDoubleForKey:@"rectOriginX"];
	double rectOriginY = [decoder decodeDoubleForKey:@"rectOriginY"];
	double rectWidth = [decoder decodeDoubleForKey:@"rectWidth"];
	double rectHeight = [decoder decodeDoubleForKey:@"rectHeight"];
	rect = CGRectMake(rectOriginX, rectOriginY, rectWidth, rectHeight);
	
	double a = [decoder decodeDoubleForKey:@"transformA"];
	double b = [decoder decodeDoubleForKey:@"transformB"];
	double c = [decoder decodeDoubleForKey:@"transformC"];
	double d = [decoder decodeDoubleForKey:@"transformD"];
	double tx = [decoder decodeDoubleForKey:@"transformTX"];
	double ty = [decoder decodeDoubleForKey:@"transformTY"];
	transform = CGAffineTransformMake(a, b, c, d, tx, ty);
	
	return self;
}
@end
