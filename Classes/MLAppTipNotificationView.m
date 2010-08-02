//
//  MLAppTipNotificationView.m
//  itryiton
//
//  Created by Mark Lorenz on 10/4/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MLAppTipNotificationView.h"


@implementation MLAppTipNotificationView

+(id) alloc{
	BOOL tempStore = [MLAppTipBubbleView tipsEnabled];
	[MLAppTipBubbleView setTipsEnabled:YES];
		id tempObject = [super alloc];
	[MLAppTipBubbleView setTipsEnabled:tempStore];
		return tempObject;
}

/*
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}
*/

- (void)drawRect:(CGRect)rect {
    // Drawing code
}


- (void)dealloc {
    [super dealloc];
}


@end
