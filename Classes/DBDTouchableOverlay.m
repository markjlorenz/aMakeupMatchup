
//
//  iTWMapView.m
//  iTheeWed
//
//  Created by Mark Lorenz on 1-Mar-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "DBDTouchableOverlay.h"


@interface DBDTouchableOverlay (DBDTouchableOverlay_hidden)

@end

@implementation DBDTouchableOverlay
@synthesize _delegate;

- (void)dealloc {
	
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
    [super dealloc];
}

-(id) initWithFrame:(CGRect)frame delegate:(NSObject <DBDTouchableOverlayDelegate> *)delegate{
	if (self = [super initWithFrame:frame]){
		self.delegate = delegate;
		self.backgroundColor = [UIColor clearColor];
	}
	return self;
}

@end

@implementation DBDTouchableOverlay (DBDTouchableOverlay_hidden)

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if ([self.delegate respondsToSelector:@selector(touchesBegan:withEvent:)])
		[self.delegate touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	if ([self.delegate respondsToSelector:@selector(touchesMoved:withEvent:)])
		[self.delegate touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	if ([self.delegate respondsToSelector:@selector(touchesEnded:withEvent:)])
		[self.delegate touchesEnded:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
	if ([self.delegate respondsToSelector:@selector(touchesCancelled:withEvent:)])
		[self.delegate touchesCancelled:touches withEvent:event];
}

@end