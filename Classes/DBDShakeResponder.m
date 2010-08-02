//
//  DBDShakeResponder.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 29-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "DBDShakeResponder.h"


@implementation DBDShakeResponder
@synthesize _observer;

@end

@implementation DBDShakeResponder (DBDShakeResponder_hidden)

-(void)dealloc{
	
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
	[super dealloc];
}

-(id) initWithSuperView:(UIView*)superView observer:(id)observer{
	if (self = [super initWithFrame:CGRectZero]){
		[superView addSubview:self];
		self.observer = observer;
	}
	return self;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if ( event.subtype == UIEventSubtypeMotionShake ){
        // Put in code here to handle shake
		if ([_observer respondsToSelector:@selector(deviceShaken)])
			[_observer deviceShaken];
		
    }
	
    if ( [super respondsToSelector:@selector(motionEnded:withEvent:)] )
        [super motionEnded:motion withEvent:event];
}

- (BOOL)canBecomeFirstResponder{ return YES; }

@end