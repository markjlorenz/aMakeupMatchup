//
//  DBDMovableView.m
//  UniversalCardUITest
//
//  Created by Mark Lorenz on 12/10/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DBDMovableView.h"


@implementation DBDMovableView
@synthesize observers;
@synthesize _image;
@synthesize allowObjectMove;
@synthesize touchCurrentlyHeld;

- (void)dealloc {
	[observers release];
	[_image release];
	[self removeObserver:self forKeyPath:@"center"];
	
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		observers = [[NSMutableSet alloc] init];
		self.allowObjectMove = YES;
		[self addObserver:self forKeyPath:@"center" options:(NSKeyValueObservingOptionNew) context:NULL];
    }
    return self;
}

- (id)initWithImage:(UIImage*)image {
    if ([self initWithFrame:CGRectMake(0.0, 0.0, image.size.width, image.size.height)]) {
        self.image = image;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
	//if (_image){  we need to be able to draw blank
		[_image drawInRect:rect];
	//}
}

-(void) registerObserver:(id <DBDMovableViewObserver>)regsitrant{
	[observers addObject:regsitrant];
}
-(void) deregisterObserver:(id <DBDMovableViewObserver>)regsitrant{
	if(regsitrant) // can not remove NIL from NSSet
		[observers removeObject:regsitrant];
}

@end

@implementation DBDMovableView (DBDMovableView_hidden)
#pragma mark --Touch Methods--
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
	touchCurrentlyHeld = NO;
	[touchHoldTimer invalidate]; //this is important, becuase timers do not like to be reasigned while they are still valid
	touchHoldTimer = nil;
	touchHoldTimer = [NSTimer scheduledTimerWithTimeInterval:DBDMovableViewHoldTime target:self selector:@selector(touchTimerHelper:) userInfo:[NSArray arrayWithObjects:touches, event, nil] repeats:NO];
	CGPoint touchLoaction = [[touches anyObject] locationInView:self.superview];
	touchOffsetFromCenter = CGSizeMake(touchLoaction.x-self.center.x, touchLoaction.y-self.center.y);
	
	NSSet *immutableObservers = [observers copy];  //as part of a clean up routine our observers might deregister themselves, so we make an immutable copy.
	for (id observer in immutableObservers)
		if ([observer respondsToSelector:@selector(touchesBegan:forMovableView:event:)])
			[observer touchesBegan:touches forMovableView:self event:event];
	[immutableObservers release];
	
}
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{
	[touchHoldTimer invalidate];
	touchHoldTimer = nil;
	if (!touchCurrentlyHeld)
		touchHoldTimer = [NSTimer scheduledTimerWithTimeInterval:DBDMovableViewHoldTime target:self selector:@selector(touchTimerHelper:) userInfo:[NSArray arrayWithObjects:touches, event, nil] repeats:NO];
	
	if(allowObjectMove){
		//self.center = [[touches anyObject] locationInView:self.superview];
		CGPoint touchLoaction = [[touches anyObject] locationInView:self.superview];
		self.center = CGPointMake(touchLoaction.x-touchOffsetFromCenter.width, touchLoaction.y-touchOffsetFromCenter.height);
	}
	
	NSSet *immutableObservers = [observers copy];  //as part of a clean up routine our observers might deregister themselves, so we make an immutable copy.
	for (id observer in immutableObservers)
		if ([observer respondsToSelector:@selector(touchesMoved:forMovableView:event:)])
			[observer touchesMoved:touches forMovableView:self event:event];
	[immutableObservers release];
}
-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event{
	[touchHoldTimer invalidate];
	touchHoldTimer = nil;
	//allowObjectMove = NO;
	//self.exclusiveTouch = NO;
	
	NSSet *immutableObservers = [observers copy];  //as part of a clean up routine our observers might deregister themselves, so we make an immutable copy.
	for (id observer in immutableObservers)
		if ([observer respondsToSelector:@selector(touchesEnded:forMovableView:event:)])
			[observer touchesEnded:touches forMovableView:self event:event];
	[immutableObservers release];
	
	touchCurrentlyHeld = NO;
}

-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event{
	[touchHoldTimer invalidate];
	touchHoldTimer = nil;
	touchCurrentlyHeld = NO;
	
	NSSet *immutableObservers = [observers copy];  //as part of a clean up routine our observers might deregister themselves, so we make an immutable copy.
	for (id observer in immutableObservers)
		if ([observer respondsToSelector:@selector(touchesCancelled:forMovableView:event:)])
			[observer touchesCancelled:touches forMovableView:self event:event];
	[immutableObservers release];
}
	
-(void)touchesHeld:(NSSet*)touches forEvent:(UIEvent*)event{
	//allowObjectMove = YES;
	//self.exclusiveTouch = YES;
	touchCurrentlyHeld = YES;
	
	NSSet *immutableObservers = [observers copy];  //as part of a clean up routine our observers might deregister themselves, so we make an immutable copy.
	for (id observer in immutableObservers)
		if ([observer respondsToSelector:@selector(touchesHeld:forMovableView:event:)])
			[observer touchesHeld:touches forMovableView:self event:event];
	[immutableObservers release];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if(keyPath == @"center"){
		NSSet *immutableObservers = [observers copy];  //as part of a clean up routine our observers might deregister themselves, so we make an immutable copy.
		for (id observer in immutableObservers)
			if ([observer respondsToSelector:@selector(movableView:didMoveCenterTo:inView:)])
				[observer movableView:self didMoveCenterTo:self.center inView:self.superview];
		[immutableObservers release];
	}
}

-(void)touchTimerHelper:(NSTimer*)timer{
	[self touchesHeld:[timer.userInfo objectAtIndex:0] forEvent:[timer.userInfo objectAtIndex:1]];
	if(touchHoldTimer != nil){
		[touchHoldTimer invalidate];
		touchHoldTimer = nil;
	}
}


@end
