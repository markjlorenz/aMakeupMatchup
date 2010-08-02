//
//  DBDPlayingCardView.m
//  UniversalCardUITest
//
//  Created by Mark Lorenz on 11/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "DBDPlayingCardView.h"

static UIImage* reverseImage;

@implementation DBDPlayingCardView
@synthesize obverseImage;
@synthesize obverseImageView;
@synthesize reverseImageView;
@synthesize visibleSide;
@synthesize momentumStopPoint;

- (void)dealloc {
	[obverseImage release];
	[obverseImageView release];
	[reverseImageView release];
	
	[super dealloc];
}

+(DBDPlayingCardView*) alloc{
	self = [super alloc];
	if(!reverseImage)
		reverseImage = [UIImage imageNamed:@"nicubunu_Reverse.png"];
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		self.obverseImage = [UIImage imageNamed:@"nicubunu_Reverse.png"];
		self.obverseImageView = [[UIImageView alloc] initWithImage:obverseImage];
		self.reverseImageView = [[UIImageView alloc] initWithImage:reverseImage];
		
		self.frame = reverseImageView.frame;
		[self addSubview:obverseImageView];
		[self addSubview:reverseImageView];
		obverseImageView.contentMode = UIViewContentModeScaleAspectFit;
		obverseImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		reverseImageView.contentMode = UIViewContentModeScaleAspectFit;
		reverseImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

		self.userInteractionEnabled = YES;
		self.multipleTouchEnabled = YES;
		self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
		self.contentMode = UIViewContentModeScaleAspectFit;
		self.autoresizesSubviews = YES;
		
		self.visibleSide = DBDPlayingCardViewVisibleSideReverse;
	}
    return self;
}

-(void) turnCardToSide:(DBDPlayingCardViewVisibleSide)side{
	if(side == DBDPlayingCardViewVisibleSideFlip){
		if (self.visibleSide == DBDPlayingCardViewVisibleSideObverse)
			self.visibleSide = DBDPlayingCardViewVisibleSideReverse;
		else
			self.visibleSide = DBDPlayingCardViewVisibleSideObverse;
		[self cardFlip];
	}
	else if(side == DBDPlayingCardViewVisibleSideObverse){
		if (obverseImageView != [self.subviews objectAtIndex:1]){//if true, the it's already on top
			self.visibleSide = DBDPlayingCardViewVisibleSideObverse;
			[self cardFlip];
		}
	}
	else if(side == DBDPlayingCardViewVisibleSideReverse){
		if (reverseImageView != [self.subviews objectAtIndex:1]){//if true, the it's already on top
			self.visibleSide = DBDPlayingCardViewVisibleSideReverse;
			[self cardFlip]; 
		}
	}
}


-(void) performMoveEndedAnimationFromEndPoint:(CGPoint)endPoint withPreviousPoint:(CGPoint)previousPoint{
	if (abs((abs(previousPoint.x) - abs(endPoint.x))) > kDBDCardMovementSensivity || 
		abs((abs(previousPoint.y) - abs(endPoint.y))) > kDBDCardMovementSensivity){
		
		CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"]; //released in didStop
		animation.delegate = self; //the call back notifies the network
		NSUInteger pointsInPath; //will be zero'd by function
		CGMutablePathRef momentumPath = [self newMomentumPathFrom:endPoint	previousPoint:previousPoint resultingPointCount:&pointsInPath];
		animation.path = momentumPath;
		animation.duration =  kDBDCardMomentumTime * pointsInPath;
		[self.layer addAnimation:animation forKey:@"momentumAnimation"];
		self.layer.position = momentumStopPoint;  //the hidden method: - (id<CAAction>)actionForLayer:(CALayer *)theLayer forKey:(NSString *)theKey; is used for disabling the implicit animation.  THIS MAY HAVE SIDE EFFECTS!

		
		CGPathRelease(momentumPath);

	}
	else //other methods will be expecting notifiction when animtion finished, but they also need to know some state variables if animation is not run
		[self performSelectorOnMainThread:@selector(animationDidStop:finished:) withObject:nil waitUntilDone:NO];  // eqivalent to: //		[self animationDidStop:nil finished:YES];   but will preserve the intended order of method calls: touchesEnded and then momentumAnimationFinished.
}
@end

#pragma mark ---Hidden Methods---
@implementation DBDPlayingCardView (DBDPlayingCardView_Hidden)
-(void)cardFlip{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.7];
	[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self cache:NO];
		[self exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
	[UIView commitAnimations];
}

-(void)turnCardToSideForTouch:(DBDPlayingCardViewVisibleSide)side{
	[self turnCardToSide:side];
}

#pragma mark --Touch Methods--
-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event{
	[self.layer removeAnimationForKey:@"momentumAnimation"];
	touchCurrentlyHeld = NO;
	singleTap = NO;
	_waitingForNextTap = YES;
	[touchHoldTimer invalidate];
	touchHoldTimer = nil;
	touchHoldTimer = [NSTimer scheduledTimerWithTimeInterval:DBDMovableViewHoldTime target:self selector:@selector(touchTimerHelper:) userInfo:[NSArray arrayWithObjects:touches, event, nil] repeats:NO];
	CGPoint touchLoaction = [[touches anyObject] locationInView:self.superview];
	touchOffsetFromCenter = CGSizeMake(touchLoaction.x-self.center.x, touchLoaction.y-self.center.y);
	
	NSArray *methodVariablesPackage = [NSArray arrayWithObjects:touches, event, nil]; //From the Doc: This method retains the receiver and the anArgument parameter until after the selector is performed.
	switch ([[touches anyObject] tapCount]) {
		case 1:		
			singleTap = YES;
			[self performSelector:@selector(singleTapMethod:) withObject:methodVariablesPackage afterDelay:kMultiTapDelay];
			break;
		case 2:
			singleTap = NO;
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapMethod:) object:previousTouchEvent];
			[self performSelector:@selector(doubleTapMethod:) withObject:methodVariablesPackage afterDelay:kMultiTapDelay];
			break;
		case 3:
			singleTap = NO;			
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doubleTapMethod:) object:previousTouchEvent];
			[self performSelector:@selector(trippleTapMethod:) withObject:methodVariablesPackage afterDelay:kMultiTapDelay];
			break;
		default:
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(trippleTapMethod:) object:previousTouchEvent];
			NSLog(@"my, that's a lot of taps.  I'm not morse code ya' know?");
			break;
	}
	previousTouchEvent = methodVariablesPackage;  
}

-(void) singleTapMethod:(NSArray*)touchMethodVariables{
	NSSet *touches = [touchMethodVariables objectAtIndex:0];
	UIEvent *event = [touchMethodVariables objectAtIndex:1];
	_waitingForNextTap = NO;
	
	for (id observer in observers)
		if ([observer respondsToSelector:@selector(touchesBegan:forMovableView:event:)])
			[observer touchesBegan:touches forMovableView:self event:event];
}

-(void) doubleTapMethod:(NSArray*)touchMethodVariables{
	NSSet *touches = [touchMethodVariables objectAtIndex:0];
	UIEvent *event = [touchMethodVariables objectAtIndex:1];
	_waitingForNextTap = NO;
	
	[self turnCardToSideForTouch:DBDPlayingCardViewVisibleSideFlip];
	
	for (id observer in observers)
		if ([observer respondsToSelector:@selector(touchesBegan:forMovableView:event:)])
			[observer touchesBegan:touches forMovableView:self event:event];
}

-(void) trippleTapMethod:(NSArray*)touchMethodVariables{
	NSSet *touches = [touchMethodVariables objectAtIndex:0];
	UIEvent *event = [touchMethodVariables objectAtIndex:1];
	_waitingForNextTap = NO;
	
	[self.superview bringSubviewToFront:self]; 
}
-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event{
	NSArray *methodVariablesPackage = [NSArray arrayWithObjects:touches, event, nil]; 
	if (singleTap) {
		if (_waitingForNextTap){
			[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleTapMethod:) object:previousTouchEvent];
			[self singleTapMethod:methodVariablesPackage];
			return;
		}
			[super touchesMoved:touches withEvent:event];
	}
}


-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event{	
	if (singleTap) {
		if (allowObjectMove){		
			CGPoint previousLocation = [[touches anyObject] previousLocationInView:self.superview];
			CGPoint currentLocation = [[touches anyObject] locationInView:self.superview];
			self.momentumStopPoint = currentLocation; //this will be overridden by the animaion if needed.
			[self performMoveEndedAnimationFromEndPoint:currentLocation withPreviousPoint:previousLocation];
		}
			
		[super touchesEnded:touches withEvent:event]; //call to super has to happen after all this or else the frame is changing after other guys are setting it.
	}
	
	[touchHoldTimer invalidate];
	touchHoldTimer = nil;
	touchCurrentlyHeld = NO;
}
-(void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event{
	[self touchesEnded:touches withEvent:event]; // we want the same behavior, especially in the cause of the card being inside a DBDTiledView
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag{ 	
	for (id <DBDPlayingCardViewObserver> observer in observers){
		if ([(NSObject*)observer respondsToSelector:@selector(momentumAnimationDidStopForCard:)])
			[observer momentumAnimationDidStopForCard:self];
	}
}

-(CGMutablePathRef)newMomentumPathFrom:(CGPoint)currentPoint previousPoint:(CGPoint)previousPoint resultingPointCount:(NSUInteger*)count{
	CGMutablePathRef path = CGPathCreateMutable();
	CGFloat pathStepSizeX = currentPoint.x - previousPoint.x;
	CGFloat pathStepSizeY = currentPoint.y - previousPoint.y;
	CGPoint nextPathPoint = currentPoint;
	CGPoint currentPathPoint = previousPoint;
	NSUInteger iterationCount = 0;
	
	CGPathMoveToPoint(path, NULL, nextPathPoint.x, nextPathPoint.y);
	[self newDebugRayTrace]; //	DEBUG ONLY
	
	while (abs(abs(currentPathPoint.x)-abs(nextPathPoint.x)) >= 0.01 || abs(abs(currentPathPoint.y)-abs(nextPathPoint.y)) >= 0.01){

		currentPathPoint.x = nextPathPoint.x;
		nextPathPoint.x = (pathStepSizeX + currentPathPoint.x);
		currentPathPoint.y = nextPathPoint.y;
		nextPathPoint.y = (pathStepSizeY + currentPathPoint.y);

//		if(!CGRectContainsPoint(cardTable.discardRect, CGPointMake(nextPathPoint.x, nextPathPoint.y))){
		if(1){
			
			// Handle the edge cases
			if ((nextPathPoint.x) < 0.0){
				nextPathPoint.x = (pathStepSizeX + currentPathPoint.x) * -1.0;
				pathStepSizeX *= -1.0;
			}
			else if ((nextPathPoint.x) > self.superview.bounds.size.width){
				nextPathPoint.x = self.superview.layer.bounds.size.width - ((pathStepSizeX + currentPathPoint.x)-self.superview.layer.bounds.size.width);
				pathStepSizeX *= -1.0;
			}

			if ((nextPathPoint.y) < 0.0){
				nextPathPoint.y = (pathStepSizeY + currentPathPoint.y) * -1.0;
				pathStepSizeY *= -1.0;
			}
			else if (nextPathPoint.y > self.superview.bounds.size.height){
				nextPathPoint.y = self.superview.layer.bounds.size.height - ((pathStepSizeY + currentPathPoint.y)-self.superview.layer.bounds.size.height);
				pathStepSizeY *= -1.0;
			}
		}
		CGPathAddLineToPoint(path, NULL, nextPathPoint.x, nextPathPoint.y);

		//[self addDebugRayTracePoint:nextPathPoint]; //DEBUG ONLY
		
		//[MLPrimitives NSLogCGPoint:nextPathPoint withMessage:@"next path point: "];
		//[MLPrimitives NSLogCGPoint:currentPathPoint withMessage:@"current path point: "];
		pathStepSizeX *= kDBDCardMomentumDragCoef;
		pathStepSizeY *= kDBDCardMomentumDragCoef;
		iterationCount++;
	}
	if(!iterationCount)
		NSLog(@"not iterated at all");
	self.momentumStopPoint = nextPathPoint;
	*count = iterationCount;
	return path;
}

-(void) newDebugRayTrace{
	for (UIView *rayPointView in debugRayTraceViews)
		[rayPointView removeFromSuperview];
	
	[debugRayTraceViews release];
	debugRayTraceViews = [[NSMutableArray alloc] init];
}

-(void) addDebugRayTracePoint:(CGPoint)point{
	UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 3.0, 3.0)];
	
	[tempView setCenter:point];
	tempView.backgroundColor = [UIColor whiteColor];
	[self.superview addSubview:tempView];
	[debugRayTraceViews addObject:tempView];
	
	[tempView performSelector:@selector(removeFromSuperviewAnimated:) withObject:[[NSObject alloc] autorelease] afterDelay:2.0]; // the odd [[NSObject alloc] autorelease] is a sneaky way to pass a true bool
	[tempView release];
}
	
- (id<CAAction>)actionForLayer:(CALayer *)theLayer forKey:(NSString *)theKey{
//	NSLog(@"action cancelled: %@", [theLayer description]);
	return [NSNull null];
}
@end