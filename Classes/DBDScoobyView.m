//
//  DBDScoobyView.m
//  iTheeWed
//
//  Created by Mark Lorenz on 27-Mar-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "DBDScoobyView.h"


@interface DBDScoobyView (DBDScoobyView_hidden)

@end

@implementation DBDScoobyView

- (void)dealloc {
	[depths release];
	[motions release];
	[previousAcceleration release];
	
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		[self setup];
	}
    return self;
}

- (void)awakeFromNib{
	[self setup];
}

-(void) setup{
//	self.userInteractionEnabled = NO;
	
	depths = [[NSMutableDictionary alloc] init];
	motions = [[NSMutableDictionary alloc] init];
}

-(void) beginScoobyScroll{
	UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
	accelerometer.updateInterval = 1.0/60.0;
	accelerometer.delegate = self;
	previousAcceleration = nil;	
}

-(void) endScoobyScroll{
	[UIAccelerometer sharedAccelerometer].delegate = nil;
}

- (void)addSubview:(UIView*)view withDepth:(CGFloat)depth{
	[self insertSubview:view atIndex:self.subviews.count withDepth:depth];
}

- (void)insertSubview:(UIView*)view atIndex:(NSInteger)index withDepth:(CGFloat)depth{
	DBDScoobyScrollView *scrollView = [[DBDScoobyScrollView alloc] initWithFrame:view.frame];
//	scrollView.userInteractionEnabled = NO;
	scrollView.contentSize = view.bounds.size;
	view.frame = scrollView.bounds;
	[scrollView addSubview:view];
	
	[super insertSubview:scrollView atIndex:index];
	[scrollView release];

	[depths setObject:[NSNumber numberWithDouble:(double)depth] forKey:[NSValue valueWithPointer: scrollView]];
}

- (void)scrollView:(DBDScoobyScrollView*)scrollView willRemoveSubview:(UIView *)subview{
	//clear the contents of depths and motions
		
	for (NSValue *scrollViewPointer in depths){
		if ([[NSValue valueWithPointer:scrollView] isEqualToValue:scrollViewPointer]){
			[depths removeObjectForKey:scrollViewPointer];
			[motions removeObjectForKey:scrollViewPointer];
			[scrollView removeFromSuperview];
			break;
		}
	}
}

@end

@implementation DBDScoobyView (DBDScoobyView_hidden)

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
	//physics equations    d = (v0)t + 1/2 at2     v = (vo) + at
	if (!previousAcceleration){ //skip the first update
		previousAcceleration = [acceleration retain];
		return;
	}
	
	//NSTimeInterval t = acceleration.timestamp - previousAcceleration.timestamp;
	NSTimeInterval t = accelerometer.updateInterval;  //this looks better because it wont jerk ahead.
	double distanceX = (0.5*acceleration.x*pow(t, 2.0))* kDBDScoobyViewSensitivity;
	
	for (NSValue *scrollViewPointer in depths){
		DBDScoobyScrollView *scrollView = nil;
		for (DBDScoobyScrollView *searchForView in self.subviews){
			if ([[NSValue valueWithPointer:searchForView] isEqualToValue:scrollViewPointer]){
				scrollView = searchForView;
				break;
			}
		}
		
		if ([scrollView isKindOfClass:[DBDScoobyScrollView class]]){ //want to be a little defensive here 
			double viewMotion = [[depths objectForKey:scrollViewPointer] doubleValue] *distanceX;  //since this class is controlling the scroll view, only one subview will there there
			double totalMotion = viewMotion + [[motions objectForKey:scrollViewPointer] doubleValue];
			
			//crummy temporary solution  I'd rather the transation be seamless, not with a giant one content width seam.
			if (totalMotion >= scrollView.contentSize.width)
				totalMotion = -scrollView.contentSize.width;
			else if (totalMotion <= -scrollView.contentSize.width)
				totalMotion = scrollView.contentSize.width;
			
			[motions setObject:[NSNumber numberWithDouble:totalMotion]  forKey:scrollViewPointer];
			scrollView.contentOffset = CGPointMake(totalMotion, scrollView.contentOffset.y);
		}
	}

	[previousAcceleration release];
	previousAcceleration = [acceleration retain];
}

//back up touch based motion
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//	UITouch *touch = [touches anyObject];
//	CGFloat distanceX = [touch locationInView:self].x - [touch previousLocationInView:self].x;
//	
//	for (NSValue *scrollViewPointer in depths){
//		UIScrollView *scrollView = nil;
//		for (UIScrollView *searchForView in self.subviews){
//			if ([[NSValue valueWithPointer:searchForView] isEqualToValue:scrollViewPointer]){
//				scrollView = searchForView;
//				break;
//			}
//		}
//		
//		if ([scrollView isKindOfClass:[UIScrollView class]]){ //want to be a little defensive here 
//			CGFloat viewMotion = [[depths objectForKey:scrollViewPointer] floatValue] *distanceX;  //since this class is controlling the scroll view, only one subview will there there
//			//CGFloat viewMotion = [[depths objectForKey:scrollViewPointer] floatValue] / sin(theta);  //since this class is controlling the scroll view, only one subview will there there
//			scrollView.contentOffset = CGPointMake( scrollView.contentOffset.x + viewMotion, scrollView.contentOffset.y);
//		}
//	}	
//}

@end