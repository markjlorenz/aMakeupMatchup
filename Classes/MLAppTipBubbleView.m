//
//  MLAppTipBubbleView.m
//  itryiton
//
//  Created by Mark Lorenz on 10/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MLAppTipBubbleView.h"

@interface MLAppTipBubbleView (hidden)

#pragma mark --Private Methods--
+ (NSString *)dataFilePath;
+(void) bootStrapDataFile;
+(void) addTipToClass:(MLAppTipBubbleView*)tip;
+(void) removeTipFromClass:(MLAppTipBubbleView*)tip;

-(void)dismissAnimation;
-(id) initWithText:(NSString*)tipText superView:(UIView*)view tipBubbleImage:(UIImage*)tipBubbleImage tipTextFrame:(CGRect)textFrame autoDismissTime:(NSTimeInterval)time;
-(void)calculateStretchCoordinates: (MLAppTipBubbleType)type;
@end

@implementation MLAppTipBubbleView
@synthesize tipBubbleImageView;
@synthesize tipTextView;
@synthesize dismissAnimationType;
@synthesize lifeCycleTimer;
@synthesize xButton;

+(id) alloc{// we are overwriting alloc here, because if the tips are enabled, I don't want to waste memory allocating them.
	if ([self tipsEnabled])
		return [super alloc];
	else
		return nil;
}

+(NSArray*) activeAppTips{return visibleTips;}

+(void) addTipToClass:(MLAppTipBubbleView*)tip{
	if (!visibleTips)
		visibleTips = [[NSMutableArray alloc] init];
	[visibleTips addObject:tip];
}

+(void) removeTipFromClass:(MLAppTipBubbleView*)tip{[visibleTips removeObject:tip];}

-(id) initWithText:(NSString*)tipText superView:(UIView*)view type:(MLAppTipBubbleType)type autoDismissTime:(NSTimeInterval)time{
	[MLAppTipBubbleView addTipToClass:self];
	
	bubbleType = type;
	UIImage *tipBubbleImage;
	CGRect tipTextFrame;
	CGFloat fontSize = 13.0;
	
	[self calculateStretchCoordinates:type];
	
	switch (type) {
		case MLAppTipBubbleTagType:;
			tipBubbleImage = [UIImage imageNamed:@"TagTypeTipBubble.png"];
			tipBubbleImage = [tipBubbleImage stretchableImageWithLeftCapWidth:stretchCoordinates.width topCapHeight:stretchCoordinates.height]; 
			tipTextFrame = CGRectMake(65.0, 10.0, 295.0 - 65.0, 56.0);
			
			self = [self initWithText:tipText superView:view tipBubbleImage:tipBubbleImage tipTextFrame:tipTextFrame autoDismissTime:time];
			
			UIImage *xButtonImage = [UIImage imageNamed:@"RedXButton.png"];
			self.xButton = [UIButton buttonWithType:UIButtonTypeCustom];
			[xButton setImage:xButtonImage forState:UIControlStateNormal];
			xButton.frame = CGRectMake(tipBubbleImageView.frame.size.width-xButtonImage.size.width*1.125, tipBubbleImageView.frame.size.height-xButtonImage.size.height/1.75, xButtonImage.size.width, xButtonImage.size.height);
			[xButton addTarget:lifeCycleTimer action:@selector(invalidate) forControlEvents:UIControlEventTouchUpInside];
			[xButton addTarget:self action:@selector(dismissAnimation) forControlEvents:UIControlEventTouchUpInside];
			[self addSubview:xButton];
			
			self.autoresizesSubviews = NO;
			self.bounds = CGRectMake(0.0, 0.0, self.bounds.size.width, self.bounds.size.height+xButtonImage.size.height/1.75);
			return self;
			break;
		case MLAppTipBubbleLowerLeft:;
			tipBubbleImage = [UIImage imageNamed:@"App Tip Bubble_LowerLeft.png"];
//			tipBubbleImage = [tipBubbleImage stretchableImageWithLeftCapWidth:23.0 topCapHeight:15.0]; 
//			tipTextFrame = CGRectMake(16.0, 8.0, 29.0-16.0, 22.0-8.0);
			tipBubbleImage = [tipBubbleImage stretchableImageWithLeftCapWidth:stretchCoordinates.width topCapHeight:stretchCoordinates.height]; 
			tipTextFrame = CGRectMake(stretchCoordinates.width, stretchCoordinates.height, [tipText sizeWithFont:[UIFont systemFontOfSize:fontSize]].width+10.0, [tipText sizeWithFont:[UIFont systemFontOfSize:fontSize]].height);
			return [self initWithText:tipText superView:view tipBubbleImage:tipBubbleImage tipTextFrame:tipTextFrame autoDismissTime:time];
			break;
		case MLAppTipBubbleLowerRight:;
			tipBubbleImage = [UIImage imageNamed:@"App Tip Bubble_LowerRight.png"];
			tipBubbleImage = [tipBubbleImage stretchableImageWithLeftCapWidth:stretchCoordinates.width topCapHeight:stretchCoordinates.height]; 
			tipTextFrame = CGRectMake(stretchCoordinates.width, stretchCoordinates.height, [tipText sizeWithFont:[UIFont systemFontOfSize:fontSize]].width+10.0, [tipText sizeWithFont:[UIFont systemFontOfSize:fontSize]].height);
			return [self initWithText:tipText superView:view tipBubbleImage:tipBubbleImage tipTextFrame:tipTextFrame autoDismissTime:time];
			break;
		case MLAppTipBubbleLowerRightDown:;
			tipBubbleImage = [UIImage imageNamed:@"App Tip Bubble_LowerRight_Down.png"];
			tipBubbleImage = [tipBubbleImage stretchableImageWithLeftCapWidth:stretchCoordinates.width topCapHeight:stretchCoordinates.height]; 
			tipTextFrame = CGRectMake(stretchCoordinates.width, stretchCoordinates.height, [tipText sizeWithFont:[UIFont systemFontOfSize:fontSize]].width+10.0, [tipText sizeWithFont:[UIFont systemFontOfSize:fontSize]].height);
			return [self initWithText:tipText superView:view tipBubbleImage:tipBubbleImage tipTextFrame:tipTextFrame autoDismissTime:time];
			break;
		case MLAppTipBubbleUpperRightUp:;
			tipBubbleImage = [UIImage imageNamed:@"App Tip Bubble_UpperRight_Up.png"];
			tipBubbleImage = [tipBubbleImage stretchableImageWithLeftCapWidth:stretchCoordinates.width topCapHeight:stretchCoordinates.height]; 
			tipTextFrame = CGRectMake(stretchCoordinates.width, stretchCoordinates.height, [tipText sizeWithFont:[UIFont systemFontOfSize:fontSize]].width+10.0, [tipText sizeWithFont:[UIFont systemFontOfSize:fontSize]].height);
			return [self initWithText:tipText superView:view tipBubbleImage:tipBubbleImage tipTextFrame:tipTextFrame autoDismissTime:time];
			break;
		case MLAppTipBubbleLowerLeftDown:;
			tipBubbleImage = [UIImage imageNamed:@"App Tip Bubble_LowerLeft_Down.png"];
			tipBubbleImage = [tipBubbleImage stretchableImageWithLeftCapWidth:stretchCoordinates.width topCapHeight:stretchCoordinates.height]; 
			tipTextFrame = CGRectMake(stretchCoordinates.width, stretchCoordinates.height, [tipText sizeWithFont:[UIFont systemFontOfSize:fontSize]].width+10.0, [tipText sizeWithFont:[UIFont systemFontOfSize:fontSize]].height);
			return [self initWithText:tipText superView:view tipBubbleImage:tipBubbleImage tipTextFrame:tipTextFrame autoDismissTime:time];
			break;
		case MLAppTipBubbleUpperLeftUp:;
			tipBubbleImage = [UIImage imageNamed:@"App Tip Bubble_UpperLeft_Up.png"];
			tipBubbleImage = [tipBubbleImage stretchableImageWithLeftCapWidth:stretchCoordinates.width topCapHeight:stretchCoordinates.height]; 
			tipTextFrame = CGRectMake(stretchCoordinates.width, stretchCoordinates.height, [tipText sizeWithFont:[UIFont systemFontOfSize:fontSize]].width+10.0, [tipText sizeWithFont:[UIFont systemFontOfSize:fontSize]].height);
			return [self initWithText:tipText superView:view tipBubbleImage:tipBubbleImage tipTextFrame:tipTextFrame autoDismissTime:time];
			break;
			
		default:
			NSLog(@"invalid tag type used for MLAppTipBubbleView");
			return nil;
			break;
	}
}

-(void)calculateStretchCoordinates: (MLAppTipBubbleType)type{
	switch (type) {
		case MLAppTipBubbleTagType:;
			stretchCoordinates =  CGSizeMake(320.0/2.0, 72.0/2.0);
			break;
		case MLAppTipBubbleLowerLeft:;
			stretchCoordinates =  CGSizeMake(19.0, 11.0);
			break;
		case MLAppTipBubbleLowerRight:;
			stretchCoordinates =  CGSizeMake(13.0, 10.0);
			break;
		case MLAppTipBubbleLowerRightDown:;
			stretchCoordinates =  CGSizeMake(11.0, 22.0);
			break;
		case MLAppTipBubbleUpperRightUp:;
			stretchCoordinates =  CGSizeMake(10.0, 19.0);
			break;
		case MLAppTipBubbleLowerLeftDown:;
			stretchCoordinates =  CGSizeMake(11.0, 13.0);
			break;
		case MLAppTipBubbleUpperLeftUp:;
			stretchCoordinates =  CGSizeMake(11.0, 22.0);
			break;

		default:
			//return nil;
			break;	
	}
}

-(id) initWithText:(NSString*)tipText superView:(UIView*)view tipBubbleImage:(UIImage*)tipBubbleImage tipTextFrame:(CGRect)textFrame autoDismissTime:(NSTimeInterval)time{
	if (time)  //if an autoDissmiss time is used, start the timer.
		lifeCycleTimer = [NSTimer scheduledTimerWithTimeInterval:time target:self selector:@selector(autoDismiss) userInfo:nil repeats:NO];
	
	CGFloat xOriginForCenteringInSuperView = (view.frame.size.width-tipBubbleImage.size.width)/2;
	
	CGRect selfFrame;
	if (bubbleType == MLAppTipBubbleTagType)
		selfFrame = CGRectMake(xOriginForCenteringInSuperView, 10.0, tipBubbleImage.size.width, tipBubbleImage.size.height);
	else
		selfFrame = CGRectMake(xOriginForCenteringInSuperView, 10.0, textFrame.size.width+tipBubbleImage.size.width, textFrame.size.height+tipBubbleImage.size.height);
		
	if (self = [super initWithFrame:selfFrame]){
		dismissAnimationType = UIViewAnimationTransitionCurlUp;
		
		self.tipBubbleImageView = [[UIImageView alloc] initWithImage:tipBubbleImage];
//		tipBubbleImageView = [[UIImageView alloc] initWithImage:tipBubbleImage];
		tipBubbleImageView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
		
		self.tipTextView = [[MLAppTipTextView alloc] initWithFrame:textFrame]; 
//		tipTextView = [[MLAppTipTextView alloc] initWithFrame:textFrame]; 
		tipTextView.editable = NO;
		tipTextView.text = tipText;
		tipTextView.font = [UIFont systemFontOfSize:12.0];
		
		self.clipsToBounds = YES;
		self.backgroundColor = [UIColor clearColor];
		tipBubbleImageView.backgroundColor = [UIColor clearColor];
		tipTextView.backgroundColor = [UIColor clearColor];
		
		[tipBubbleImageView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[tipTextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		
		[self addSubview:tipBubbleImageView];
		[self addSubview:tipTextView];
		
		[tipBubbleImageView release];
		[tipTextView release];
	}
	
	[view addSubview:self];
	[self release];
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
}

-(void) setText:(NSString*)tipText{
	tipTextView.text = tipText;
}

-(NSString*) text{
	return tipTextView.text;
}

- (void)dealloc {
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));	
	[tipBubbleImageView release];
	[tipTextView release];
	[xButton release];
	
	[super dealloc];
}

-(void) autoDismiss{
	self.userInteractionEnabled = NO;  //to prevent the user from dismissing simultaneious with the autodismiss
	[self dismissAnimation];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	if ([[touches anyObject] tapCount] == 2){
		[lifeCycleTimer invalidate];
		[self dismissAnimation];
	}
	//the timer may need to be released here to prevent leaks if the user dismisses manually before the autoDismiss.  I'm not sure yet.
}

-(void)dismissAnimation{
	[MLAppTipBubbleView removeTipFromClass:self];  //can't do this in dealloc
	// bubble types are 1 to 6 in the enum  //!!!
	if (bubbleType >= 1 && bubbleType <= 6){// the bubble type animation looks really bad if you flip or curl it.
		
		//draw myself into a static image
		UIImage *staticImage;
		UIGraphicsBeginImageContext(self.bounds.size);
		[self.layer renderInContext:UIGraphicsGetCurrentContext()];
		staticImage = UIGraphicsGetImageFromCurrentImageContext(); //stretchableImageWithLeftCapWidth:stretchCoordinates.width topCapHeight:stretchCoordinates.height];
		UIGraphicsEndImageContext();
		UIImageView *staticView = [[UIImageView alloc] initWithImage:staticImage];
		staticView.autoresizingMask =  UIViewAutoresizingFlexibleWidth;
		[self addSubview:staticView];
		[staticView release];
		
		// dont' need these two anymore.
		[tipBubbleImageView removeFromSuperview];
		[tipTextView removeFromSuperview];
		[xButton removeFromSuperview];
		
		[UIView beginAnimations:@"tipBubbleSlide" context:nil];
		[UIView setAnimationDuration:0.7];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
 
		//self.frame = CGRectMake(0.0 - self.frame.origin.x - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
		self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, 0.0, self.frame.size.height);
		
		[UIView commitAnimations];	
	}
	
	else{
		[UIView beginAnimations:@"tipBubbleFilp" context:nil];
		[UIView setAnimationDuration:1.0];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];

		[UIView setAnimationTransition:dismissAnimationType forView:self cache:YES];
		[tipBubbleImageView removeFromSuperview];
		[tipTextView removeFromSuperview];
		[xButton removeFromSuperview];
		
		[UIView commitAnimations];	
	}
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
	[self  removeFromSuperview];
}

#pragma mark --Class Variable Methods--
+(BOOL) tipsEnabled{
	// check the class variable.  If its not YES or NO than it' not been intitialized, init it from file.
	tipsEnabled = [NSString stringWithContentsOfFile:[self dataFilePath]];
	if ([tipsEnabled isEqualToString:@"NO"])
		return NO;
	else if([tipsEnabled isEqualToString:@"YES"])
		return YES;
	else{
		[self bootStrapDataFile];
		tipsEnabled = [NSString stringWithContentsOfFile:[self dataFilePath]];
		return [self tipsEnabled];
	}
}
+(void) setTipsEnabled:(BOOL)enable{
	// set the class variable, and write it to fil
	if(enable)
		tipsEnabled = @"YES";
	else
		tipsEnabled = @"NO";
	
	[tipsEnabled writeToFile:[self dataFilePath] atomically:YES encoding:NSASCIIStringEncoding error:nil];
}

#pragma mark --Persistence Methods--
+ (NSString *)dataFilePath { 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"MLAppTipBubbleView_EnabledState.txt"]; 
} 
+(void) bootStrapDataFile {
	// Check if file exists, if not, then write the default YES to our file
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:[self dataFilePath]])
		[[NSString stringWithFormat:@"YES"] writeToFile:[self dataFilePath] atomically:YES encoding:NSASCIIStringEncoding error:nil];
}

@end


@implementation MLAppTipTextView
// I want a method to allow double tap to dismiss the view indead of activing copy/paste
- (id) initWithFrame:(CGRect)frame{
	if( self = [super initWithFrame:frame] ){
//		self.delegate = self;
	}
	return self;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	NSDate *newFireDate = [NSDate dateWithTimeIntervalSinceNow:2.0];//add two more seconds to the timer
	[[((MLAppTipBubbleView*)self.superview) lifeCycleTimer] setFireDate:newFireDate];
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
	NSLog(@"hi, I'm an infinte loop");
}


@end
