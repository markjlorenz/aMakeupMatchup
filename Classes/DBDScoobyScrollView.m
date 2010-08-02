//
//  DBDScoobyScrollView.m
//  iTheeWed
//
//  Created by Mark Lorenz on 27-Mar-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "DBDScoobyScrollView.h"
#import "DBDScoobyView.h"

@interface DBDScoobyScrollView (DBDScoobyScrollView_hidden)

@end

@implementation DBDScoobyScrollView

- (void)dealloc {
	
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
    [super dealloc];
}

-(id) initWithFrame:(CGRect)frame{
	if (self = [super initWithFrame:frame])
//		self.userInteractionEnabled = NO;
		;
	return self;
}

- (void)willRemoveSubview:(UIView *)subview{
	[((DBDScoobyView*) self.superview) scrollView:self willRemoveSubview:subview];
	// subview will be destroyed when this view is destroyed in DBDScoobyView
}

@end

@implementation DBDScoobyScrollView (DBDScoobyScrollView_hidden)

@end