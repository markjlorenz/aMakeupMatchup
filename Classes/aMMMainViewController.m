//
//  aMMMainViewController.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 25-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "aMMMainViewController.h"
#import "aMMBuySellMakeupController.h"
#import "aMMFindMakeupController.h"
#import "aMMAllMatchingOptionsTableController.h"
#import "aMMHalfTableController.h"
#import "UIButton_DBDAdditions.h"
#import "DBDUIViewTools.h"
#import "AppInfo.h"
#import "DBDShakeResponder.h"
#import "DBDScoobyView.h"
#import <AVFoundation/AVFoundation.h>
#import "AVAudioPlayer_DBDAdditions.h"

#import "aMMDrinkMeCenterViewController.h"

@interface aMMMainViewController (aMMMainViewController_hidden)

@end

@implementation aMMMainViewController
@synthesize buySellButton;
@synthesize findButton;
@synthesize aboutThisAppButton;
@synthesize drinkMeScrollView;
@synthesize drinkMeButton;

- (void)dealloc {
	[buySellButton release];
	[findButton release];
	[aboutThisAppButton release];
	[drinkMeScrollView release];
	[drinkMeButton release];
	
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
    [super dealloc];
}

-(IBAction) buySellButtonPressed{
	[AVAudioPlayer playResouce:@"StoreBell" ofType:@"wav"];
	
	aMMBuySellMakeupController *buySellController = [[aMMBuySellMakeupController alloc] initWithNibName:@"aMMBuySellMakeup" bundle:nil];
	[self.navigationController pushViewController:buySellController animated:YES];
	[buySellController release];
}

-(IBAction) findButtonPressed{
	[AVAudioPlayer playResouce:@"Zipper" ofType:@"wav"];
	
	aMMFindMakeupController *findMakeupController = [[aMMFindMakeupController alloc] initWithNibName:@"aMMFindMakeup" bundle:nil];
	[self.navigationController pushViewController:findMakeupController animated:YES];
	[findMakeupController release];
}

-(IBAction) aboutThisAppButtonPressed{
	[AVAudioPlayer playResouce:@"LipGlossPop" ofType:@"wav"];
	
	AppInfo *appInfo = [[AppInfo alloc] initWithNibName:@"AppInfo" bundle:nil];
	[self.navigationController pushViewController:appInfo animated:YES];
	[appInfo release];
}

-(void) deviceShaken{
	[AVAudioPlayer playResouce:@"CosmeticsBagDump" ofType:@"wav"];
	
	aMMHalfTableController *halfTableController = [[[aMMHalfTableController alloc] init] autorelease];
	halfTableController.key = @"product";
	aMMAllMatchingOptionsTableController *allMatchesTable = [[aMMAllMatchingOptionsTableController alloc] initWithStyle:UITableViewStylePlain];
	allMatchesTable.matchingMakeup = [[[halfTableController objectsForSource] mutableCopy] autorelease];
	allMatchesTable.canDelete = YES;
	[self.navigationController pushViewController:allMatchesTable animated:YES];
	[allMatchesTable release];
}

-(IBAction) hiddenButtonPress{
	[AVAudioPlayer playResouce:@"CorkPop" ofType:@"wav"];
	
	aMMDrinkMeCenterViewController *drinkMe = [[aMMDrinkMeCenterViewController alloc] initWithNibName:@"aMMDrinkMeCenter" bundle:nil];
	[self.navigationController pushViewController:drinkMe animated:YES];
	[drinkMe release];
}

- (void)viewWillAppear:(BOOL)animated{
	self.navigationController.navigationBarHidden = YES;
	[shakeResponder becomeFirstResponder];	
	[drinkMeScrollView beginScoobyScroll];
	[super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
	[shakeResponder resignFirstResponder];
	[drinkMeScrollView endScoobyScroll];
	[super viewWillDisappear:YES];
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
	
//	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
	
	shakeResponder = [[DBDShakeResponder alloc] initWithSuperView:self.view observer:self];
	[shakeResponder release];

	UIView *drinkMeContainer = [[UIView alloc] initWithFrame:self.drinkMeScrollView.bounds];
	[drinkMeContainer setFrameWidth:drinkMeContainer.bounds.size.width*1.5];
	drinkMeContainer.backgroundColor = [UIColor clearColor];
	[drinkMeButton addTarget:self action:@selector(hiddenButtonPress) forControlEvents:UIControlEventTouchUpInside];
	[drinkMeButton setFrameOrigin:CGPointMake(400.0, 0.0)];
	[drinkMeContainer addSubview:drinkMeButton];
	
	[self.drinkMeScrollView addSubview:drinkMeContainer withDepth:1.5];
	[drinkMeContainer release];
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

/*
- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
*/


@end

@implementation aMMMainViewController (aMMMainViewController_hidden)


@end
