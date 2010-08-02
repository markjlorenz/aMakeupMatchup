//
//  AppInfo.m
//  BeerTemperature
//
//  Created by Mark Lorenz on 5/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "AppInfo.h"


@implementation AppInfo

@synthesize tweetText;
@synthesize tweetTextBackground;
@synthesize tweetCharsRemainingLable;
@synthesize tweetButton;
@synthesize promotionalLink;
@synthesize tweetPoster;
@synthesize scoobyView;
@synthesize appInfoDelegate;
@synthesize promotionalLabel1;
@synthesize promotionalLabel2;
@synthesize promotionalLabel3;
@synthesize promotionalImage;

- (void)dealloc {
	[tweetText release];
	[tweetTextBackground release];
	[tweetCharsRemainingLable release];
	[tweetButton release];
	[promotionalLink release];
	[tipBubblesToggle release];
	[tweetPoster release];
	[scoobyView release];
	
	[promotionalLabel1 release];
	[promotionalLabel2 release];
	[promotionalLabel3 release];
	[promotionalImage release];
	
    [super dealloc];
}


-(IBAction) tweetButtonPressed{
	[tweetPoster getUsernameAndPasswordThenPost];
	tweetPoster.tweet = tweetText.text;
}

-(IBAction) launchSafari{
	NSURL *url = [NSURL URLWithString:@"http://www.DappleBeforeDawn.com/"];
	if (![[UIApplication sharedApplication] openURL:url])
		NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
	
	MLNetFetchImageView *background = [[MLNetFetchImageView alloc] initWithFetchURL:@"http://www.DappleBeforeDawn.com/iDoStyle/mlnetfetchimageview.php" identifier:@"idostyle_appinfo_background" bootStrapImage:[UIImage imageNamed:@"AppInfoBackground.png"]];
	[self.view insertSubview:background atIndex:0]; //becuase we are loading from NIB we need to put it in the back
	[background release];
	
	navigationBarHidesSaveState = self.navigationController.navigationBarHidden;
	self.navigationController.navigationBarHidden = NO;
	self.title = @"iDoStyle App Info";
	
	{ 
		UIImage *buttonImageNormal = [UIImage imageNamed:@"whiteButton.png"]; 
		UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:12 topCapHeight:0]; 
		[tweetButton setBackgroundImage:stretchableButtonImageNormal 
									   forState: UIControlStateNormal]; 
		UIImage *buttonImagePressed = [UIImage imageNamed:@"blueButton.png"]; 
		UIImage *stretchableButtonImagePressed = [buttonImagePressed 
												  stretchableImageWithLeftCapWidth:12 topCapHeight:0]; 
		[tweetButton setBackgroundImage:stretchableButtonImagePressed 
									   forState: UIControlStateHighlighted]; 	
    }  
	
	UIImage *stretchableBubbleDetail = [[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DetailBubble" ofType:@"png"]] stretchableImageWithLeftCapWidth:20 topCapHeight:65/2]; 
	tweetTextBackground.image = stretchableBubbleDetail;
//	tweetTextBackground.frame = tweetText.frame;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotification:) name:UIKeyboardWillShowNotification object:nil];  
    
	tweetPoster = [[TweetPoster alloc] init];
	tweetPoster.delegate = self;
	
	//store the initial location of some IB objects, so they can be restored after they are moved
	tweetTextStartPosition = tweetText.frame;
	tweetCharsRemainingLableStartPosition = tweetCharsRemainingLable.frame;
	tweetTitleStartPosition = tweetTitle.frame;
	
	tweetCharsRemainingLable.text = [NSString stringWithFormat: @"%i characters remaining", [tweetPoster tweetCharactersRemaining:@""]];
	tweetCharsRemainingColor = tweetCharsRemainingLable.textColor;
	
	tipBubblesToggle.on = [MLAppTipBubbleView tipsEnabled];
	
	UIImageView  *baloon = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"ThankYou" ofType:@"png"]]];
	[scoobyView addSubview:baloon withDepth:1.5];
	[baloon release];
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
//	self.navigationController.navigationBarHidden = navigationBarHidesSaveState;
	[scoobyView endScoobyScroll];
}

-(void) viewWillAppear:(BOOL)animated{
	self.navigationController.navigationBarHidden = NO;
	[super viewWillAppear:animated];
	[scoobyView beginScoobyScroll];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)keyboardNotification:(NSNotification*)notification {  
    NSDictionary *userInfo = [notification userInfo];  
    NSValue *keyboardBoundsValue = [userInfo objectForKey:UIKeyboardBoundsUserInfoKey];  
    [keyboardBoundsValue getValue:&keyboardBounds];  
}  

- (void)textViewDidBeginEditing:(UITextView *)textView{
	if (textView == tweetText){
		tweetText.text = nil;
		[self fadeOutView:companyLogo];
		[self fadeOutView:revNo];
		[self fadeOutView:companyName];
		[self fadeOutView:visitOurWebSite];
		
		[self fadeOutView:promotionalLabel1];
		[self fadeOutView:promotionalLabel2];
		[self fadeOutView:promotionalLabel3];
		[self fadeOutView:promotionalImage];
		[self fadeOutView:promotionalLink];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		  
		CGFloat topBumper = 30.0;
		tweetTitle.center =CGPointMake(tweetTitle.center.x, topBumper + tweetTitle.bounds.size.height/2.0);  
		tweetText.frame = CGRectMake(tweetText.frame.origin.x, tweetText.frame.origin.y, tweetText.frame.size.width, tweetText.frame.size.height*1.25); //get a little bigger to allow for the whole tweet to fit
		tweetText.center = CGPointMake(tweetText.center.x, tweetTitle.frame.origin.y + tweetTitle.frame.size.height + IB_OBJECT_OFFSET + tweetText.frame.size.height/2.0);  
		tweetTextBackground.frame = tweetText.frame;
		tweetTextBackground.center = tweetText.center;
		tweetCharsRemainingLable.center = CGPointMake(tweetCharsRemainingLable.center.x, tweetText.frame.origin.y + tweetText.frame.size.height + IB_OBJECT_OFFSET + tweetCharsRemainingLable.frame.size.height/2.0);
		
		[UIView commitAnimations];
	}
}

- (void)textViewDidChange:(UITextView *)textView{
	
	tweetCharsRemainingLable.text = [NSString stringWithFormat: @"%i characters remaining", [tweetPoster tweetCharactersRemaining:tweetText.text]];
	if ((int)([tweetPoster tweetCharactersRemaining:tweetText.text]) < 0){
		tweetCharsRemainingLable.textColor = [UIColor redColor];
		tweetButton.enabled = NO;
	}
	else{
		tweetCharsRemainingLable.textColor = tweetCharsRemainingColor;
		tweetButton.enabled = YES;
	}
}
- (void)textViewDidEndEditing:(UITextView *)textView{
	if (textView == tweetText){
		[self fadeInView:companyLogo];
		[self fadeInView:revNo];
		[self fadeInView:companyName];
		[self fadeInView:visitOurWebSite];
		
		[self fadeInView:promotionalLabel1];
		[self fadeInView:promotionalLabel2];
		[self fadeInView:promotionalLabel3];
		[self fadeInView:promotionalImage];
		[self fadeInView:promotionalLink];
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		
		tweetTitle.frame =tweetTitleStartPosition;
		tweetText.frame = tweetTextStartPosition;
		tweetTextBackground.frame = tweetTextStartPosition;
		tweetCharsRemainingLable.frame = tweetCharsRemainingLableStartPosition;
		[UIView commitAnimations];
	}
}

-(NSString *)getTweetText{
	return tweetText.text;
}

-(IBAction)keyboardCloseButton{
	[tweetText resignFirstResponder];
}

-(IBAction)backButton{
		
	[appInfoDelegate shouldCloseInfo:YES sender:self];
}
-(void)fadeOutView:(UIView *)view{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	
	view.alpha = 0.0;
	//	view.transform = CGAffineTransformMakeScale(1, 0);
	//	view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,0); 
	[UIView commitAnimations];
}

-(void)fadeInView:(UIView *)view{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:1.0];
	[UIView setAnimationDelegate:self];
	
	view.alpha = 1.0;
	//	view.transform = CGAffineTransformMakeScale(1, 0);
	//	view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width,0); 
	[UIView commitAnimations];
}

-(void)shouldCloseInfo:(BOOL)willClose sender:(id)sender{
	NSLog(@"shouldClose Method not overridden");
}

-(IBAction) toggleTipBubbles{
	
	NSString *tipToggleStateMessage;
	if (tipBubblesToggle.on){
		tipToggleStateMessage = DBDLocalizedString(@"You have turned Tip Bubbles On");
		[MLAppTipBubbleView setTipsEnabled:YES];
	}
	else{
		tipToggleStateMessage = DBDLocalizedString(@"You have turned Tip Bubbles Off");
		[MLAppTipBubbleView setTipsEnabled:NO];
	}
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip Bubbles?" 
													message:tipToggleStateMessage
												   delegate:self 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert release];  
}

-(IBAction) promotinalLinkPressed{
	NSURL *url = [NSURL URLWithString:@"http://www.DappleBeforeDawn.com/amakeupmatchup/itryiton_promo.html"];
	if (![[UIApplication sharedApplication] openURL:url])
		NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

/*  THIS IS THE KIND OF METHOD WE WOULD USE TO RESET USER DEFAULTS
- (void)alertView:(UIAlertView *)alertView  clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 1 && buttonIndex == 0){
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults removeObjectForKey:kUserDefaultUsernameKey];
		[defaults removeObjectForKey:kUserDefaultPasswordKey];
	}
		
} */

@end