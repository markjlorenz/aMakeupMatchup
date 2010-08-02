//
//  DBDStdErrLog.m
//  QRreality
//
//  Created by Mark Lorenz on 1/29/10.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "DBDStdErrLog.h"

@implementation DBDStdErrLog

+(id) alloc{
	if(!allConsoles)
		allConsoles = [[NSMutableSet alloc] init];
	id newErrLog = [super alloc];
	[allConsoles addObject:newErrLog];
	return newErrLog;
}

+(void) append:(NSString*)text{
	NSLog(text);
	for (DBDStdErrLog *console in allConsoles){
		BOOL shouldScroll = NO;
		if (console.contentSize.height - console.contentOffset.y == console.bounds.size.height || 
			console.contentSize.height - console.contentOffset.y == 18){ //18 is needed for when the user went's to let autoscroll take over again.  the 18 magic number may not work for a differnet font size.
				shouldScroll = YES;
		}
		//console.text = [NSString stringWithFormat:@"%@\n%@", console.text,  text];
		//[console performSelectorOnMainThread:@selector(setText:) withObject:[NSString stringWithFormat:@"%@\n%@", console.text,  text] waitUntilDone:YES];  //YES we selected to prevent the autoreleased object from being released
		[console performSelectorOnMainThread:@selector(appendText:) withObject: text waitUntilDone:YES];  //YES we selected to prevent the autoreleased object from being released
		
		if(shouldScroll)
			[console setContentOffset:CGPointMake(0.0, console.contentSize.height-console.bounds.size.height) animated:NO];  //if you animate this, it will not work if your log updates are comming before the animation finishes
	}
}

- (void)dealloc {
	[allConsoles removeObject:self];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//		stdErrFP = fdopen (fileno (stderr) , "r");
//		if (!stdErrFP)
//			 NSLog(@"errno - %s", strerror(errno));
//		
//		[self update];
//		[NSTimer scheduledTimerWithTimeInterval:kDBDStdErrLogUpdateTime target:self selector:@selector(update) userInfo:nil repeats:YES];
		
		self.editable = NO;
		self.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.2];
		self.textColor = [UIColor colorWithRed:0x66/256.0 green:0xFF/256.0 blue:0.0 alpha:1.0];
		self.font = [UIFont fontWithName:@"Courier" size:12];
    }
    return self;
}

- (id)initAsHeader:(UIView*)superview{
    //bounds chosen over applicationFrame, b/c this is for debugging only, and we don't really care if we coverup the status bar while debug.	
	if (self = [super initWithFrame:CGRectMake(0.0, 0.0, superview.frame.size.width, kDBDStdErrLogInitAsHeaderHeight)]) {
		//		stdErrFP = fdopen (fileno (stderr) , "r");
		//		if (!stdErrFP)
		//			 NSLog(@"errno - %s", strerror(errno));
		//		
		//		[self update];
		//		[NSTimer scheduledTimerWithTimeInterval:kDBDStdErrLogUpdateTime target:self selector:@selector(update) userInfo:nil repeats:YES];
		
		self.editable = NO;
		self.backgroundColor = [UIColor colorWithRed:100.0/255.0 green:100.0/255.0 blue:100.0/255.0 alpha:0.2];
		self.textColor = [UIColor colorWithRed:0x66/256.0 green:0xFF/256.0 blue:0.0 alpha:1.0];
		self.font = [UIFont fontWithName:@"Courier" size:12];
    }
    return self;
}

//-(void) update{
//	char errBuff[2] = {0x00, '\0'};
//	do{
//		errBuff[0] = fgetc(stdErrFP);
//		self.text = [NSString stringWithFormat:@"%@%@", self.text,  [NSString stringWithCString:errBuff]];
//	}while (errBuff[0] != EOF);	
//}

@end

@implementation UITextView (UITextView_DBDStdErrLogAdditions)
-(void) appendText:(NSString*)text{
	self.text = [NSString stringWithFormat:@"%@\n%@", self.text,  text];
}
@end