//
//  aMMFindMakeupController.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 25-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "aMMFindMakeupController.h"
#import "aMMAllMatchingOptionsTableController.h"
#import <objc/runtime.h>
#import "DBDUIViewTools.h"
#import "aMMHalfTableController.h"
#import "UIButton_DBDAdditions.h"
#import "DBDGeneralMacros.h"

@interface aMMFindMakeupController (aMMFindMakeupController_hidden)
-(aMMAllMatchingOptionsTableController*) matchesTable;
- (void)setButtonMessage;
@end

@implementation aMMFindMakeupController
@synthesize allMatches;
@synthesize background;

- (void)dealloc {
	[background release];
		
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

- (void) viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	self.navigationController.navigationBarHidden = YES;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
		
	[self.allMatches applyGlossColor:UIButtonColorGreen forState:UIControlStateNormal];
}


-(void) displayHalfTableViewForProperty:(NSString*)key{
	CGFloat screenHalf; //upper left corner of the 1/2 screen table
	if ([key isEqualToString:@"product"] || [key isEqualToString:@"brand"]) {
		[halfTableView setFrameOriginY:self.view.bounds.size.height]; 
		screenHalf = self.view.bounds.size.height/2.0;
	}
	else if ([key isEqualToString:@"formula"] || [key isEqualToString:@"color"]) {
		[halfTableView setFrameOriginY:self.view.bounds.origin.y - halfTableView.bounds.size.height];
		screenHalf = self.view.bounds.origin.y;
	}
	
	halfTableController.key = key;
		
	halfTableController.additionalPredicateKeysAndValues = [self additionalPredicatesDictionary];
	[halfTableView reloadData];
	
	halfTableView.hidden = NO;
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
		[halfTableView setFrameOriginY:screenHalf];
	[UIView commitAnimations];
}


-(IBAction) backButtonPressed{
	[self.navigationController popViewControllerAnimated:YES];
}



-(IBAction) allMatchesPressed{
	aMMAllMatchingOptionsTableController *matches = [self matchesTable]; 
	matches.canDelete = YES;
	[self.navigationController pushViewController:matches animated:YES];
}

-(aMMAllMatchingOptionsTableController*) matchesTable{
	aMMAllMatchingOptionsTableController *allMatchesTable = [[[aMMAllMatchingOptionsTableController alloc] initWithStyle:UITableViewStylePlain]autorelease];
	halfTableController.key = @"product";
	halfTableController.additionalPredicateKeysAndValues = [self additionalPredicatesDictionary];
	allMatchesTable.matchingMakeup = [[[halfTableController objectsForSource] mutableCopy] autorelease];
	return allMatchesTable;
}


-(void) tableValueSelected:(NSString*)value forKey:(NSString*)key{//table controller delegate
	[super tableValueSelected:value forKey:key];
	[allMatches setTitle:DBDLocalizedString(@"All Matches") forState:UIControlStateNormal];
}

-(IBAction) hiddenButtonPress{
	[super hiddenButtonPress];
	[self setButtonMessage];
}
	
- (void)setButtonMessage{
	for (UITextField *field in [self textFields]){
		if (field.text.length){
			[allMatches setTitle:DBDLocalizedString(@"All Matches") forState:UIControlStateNormal];
			return;
		}
	}
	[allMatches setTitle:DBDLocalizedString(@"All Makeup") forState:UIControlStateNormal];
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

@end

@implementation aMMFindMakeupController (aMMFindMakeupController_hidden)

@end
