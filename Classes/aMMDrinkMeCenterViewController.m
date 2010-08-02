////
//  aMMDrinkMeCenterViewController.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 7-May-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "aMMDrinkMeCenterViewController.h"
#import "DBDTwitterSearchTableController.h"
#import "TweetPoster.h"
#import "DBDTiledView.h"
#import "UIButton_DBDAdditions.h"
#import "DBDUIViewTools.h"
#import "DBDGeneralMacros.h"
#import "DBDNetFetchTextView.h"
#import "AVAudioPlayer_DBDAdditions.h"

#import "aMMHiddenCombinationDelegate.h"

@interface aMMDrinkMeCenterViewController (aMMDrinkMeCenterViewController_hidden)

@end

@implementation aMMDrinkMeCenterViewController
@synthesize twitterFeedBackground;
@synthesize tweetTextBackground;
@synthesize twitterFeed;
@synthesize tweetText;
@synthesize tweetButton;
@synthesize hiddenButton;
@synthesize questionButton;
@synthesize tweetCharactersRemaining;
@synthesize tweetCharactersRemainingHeading;
@synthesize twitterFeedController;
@synthesize tileView;
@synthesize conversationStarterText;
@synthesize tweetCharactersRemainingColor;
@synthesize tweetPlaceholderText;
@synthesize tweetPlaceholderTextColor;

@synthesize combinationContainer;
@synthesize combination;
@synthesize unlockButton;

- (void)dealloc {
	[twitterFeedBackground release];
	[tweetTextBackground release];
	[twitterFeed release];
	[tweetText release];
	[tweetButton release];
	[hiddenButton release];
	[questionButton release];
	[tweetCharactersRemaining release];
	[tweetCharactersRemainingHeading release];
	[twitterFeedController release];
	[tweetCharactersRemainingColor release];
	[tileView release];
	[conversationStarterText cancel];
	[conversationStarterText release];
	[twitterPostContoller release];
	[tweetPlaceholderText release];
	[tweetPlaceholderTextColor release];
	
	[combinationContainer release];
	[combination release];
	[unlockButton release];
	[combinationDelegate release];
	
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
    [super dealloc];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
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

	self.navigationController.navigationBarHidden = NO;
	self.title = DBDLocalizedString(@"Makeup Chat");
	
	[tweetButton applyGlossColor:UIButtonColorGreen forState:UIControlStateNormal];	
	
	self.twitterFeedController = [[[DBDTwitterSearchTableController alloc] initWithTable:self.twitterFeed] autorelease];
	self.twitterFeed.dataSource = self.twitterFeedController;
	self.twitterFeed.delegate = self.twitterFeedController;
	self.twitterFeedController.hashTag = @"makeup-talk";
	[twitterFeedController fetchFeed];
	
	self.tweetCharactersRemainingColor = tweetCharactersRemaining.textColor;
	self.tweetPlaceholderTextColor = tweetText.textColor;
	self.tweetPlaceholderText = tweetText.text;
	
	twitterPostContoller = [[TweetPoster alloc] init];
	twitterPostContoller.delegate = self;
	twitterPostContoller.hashTag = @"#makeup-talk";
	
	conversationStarterText.URL = @"http://www.dapplebeforedawn.com/amakeupmatchup/conversationstarters.php";
	[conversationStarterText fetchFeed];
	
	//setup the tileview
//	NSArray *fileNames = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"product" ofType:@"plist"]];
//	[tileView insertTileAtEnd:questionButton];
//	for (NSString *fileName in fileNames){
//		UIImageView *tile = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"png"]]];
//		[tile setFrameHeightProportional:75.0];
//		[tileView insertTileAtEnd:tile];
//		[tile release];
//	}
	
	
	[unlockButton applyGlossColor:UIButtonColorGreen forState:UIControlStateNormal];
	combinationContainer.alpha = 0.0;
	[self.view addSubview:combinationContainer];
	combinationDelegate = [[aMMHiddenCombinationDelegate alloc] init];
	combination.delegate = combinationDelegate;
	combination.dataSource = combinationDelegate;
}

-(IBAction) tweetButtonPressed{
	if (tweetText.text.length && ![tweetText.text isEqualToString:tweetPlaceholderText]){ //dont post nothing
		twitterPostContoller.tweet = tweetText.text;
		[twitterPostContoller getUsernameAndPasswordThenPost];
	}
//clean up in the delegate method
}

-(IBAction) hiddenButtonPressed{
	if ([tweetText.text isEqualToString:@""]){
		tweetText.textColor = tweetPlaceholderTextColor;
		tweetText.text = tweetPlaceholderText;
	}
	if ([tweetText isFirstResponder])
		[tweetText resignFirstResponder];
}

-(IBAction) questionButtonPressed{
	[AVAudioPlayer playResouce:@"CorkPop" ofType:@"wav"];
	
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:DBDLocalizedString(@"What's This?")
//													message:DBDLocalizedString(@"All the questions will be answered here.")
//												   delegate:nil
//										  cancelButtonTitle:DBDLocalizedString(@"Ok")
//										  otherButtonTitles:nil];
//	[alert show];
//	[alert release];
	
	[combinationContainer fadeInWithDelegate:nil];	
}

-(void) unlockButtonPressed{
	[combinationContainer fadeOutWithDelegate:nil];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
}

@end

@implementation aMMDrinkMeCenterViewController (aMMDrinkMeCenterViewController_hidden)
- (void)textViewDidBeginEditing:(UITextView *)textView{
	if (textView == tweetText){
		tweetTextStartingFrame = tweetText.frame;
		tweetTextSmallFontSize = tweetText.font.pointSize;
		
		if ([tweetText.text isEqualToString:tweetPlaceholderText])
			tweetText.text = nil;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
			tweetText.frame = twitterFeed.frame;
		[tweetText setFrameHeight:100.0];
			tweetText.font = [UIFont systemFontOfSize:17.0];
			tweetText.textColor = [UIColor whiteColor];
		[UIView commitAnimations];
		
		[twitterFeed fadeOutWithDelegate:nil];
		[tweetTextBackground fadeOutWithDelegate:nil];
		
		[tweetCharactersRemaining fadeInWithDelegate:nil];
		[tweetCharactersRemainingHeading fadeInWithDelegate:nil];
	}
}

- (void)textViewDidChange:(UITextView *)textView{
	if (textView == tweetText){
		tweetCharactersRemaining.text = [NSString stringWithFormat: @"%i", [twitterPostContoller tweetCharactersRemaining:tweetText.text]];
		if ((int)([twitterPostContoller tweetCharactersRemaining:tweetText.text]) < 0){
			tweetCharactersRemaining.textColor = [UIColor redColor];
			tweetCharactersRemainingHeading.textColor = [UIColor redColor];
			tweetButton.enabled = NO;
		}
		else{
			tweetCharactersRemaining.textColor = tweetCharactersRemainingColor;
			tweetCharactersRemainingHeading.textColor = tweetCharactersRemainingColor;
			tweetButton.enabled = YES;
		}
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView{
	if (textView == tweetText){	
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
			tweetText.frame = tweetTextStartingFrame;
			tweetText.font = [UIFont systemFontOfSize:tweetTextSmallFontSize];
		[UIView commitAnimations];
		
		[twitterFeed fadeInWithDelegate:nil];
		[tweetTextBackground fadeInWithDelegate:nil];
		
		[tweetCharactersRemaining fadeOutWithDelegate:nil];
		[tweetCharactersRemainingHeading fadeOutWithDelegate:nil];
	}
}

-(void)tweetPoster:(TweetPoster*)tweetPoster didPost:(BOOL)successfully{
	if (successfully){
		tweetText.textColor = tweetPlaceholderTextColor;
		tweetText.text = tweetPlaceholderText;
		[twitterFeedController performSelector:@selector(fetchFeed) withObject:nil afterDelay:10.0]; //seems to take a while to populate
	}
	[tweetText resignFirstResponder];	
}
@end
