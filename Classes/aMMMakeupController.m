//
//  aMMMakeupController.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 28-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "aMMMakeupController.h"
#import "aMMHalfTableController.h"
#import "DBDGeneralMacros.h"
#import <objc/runtime.h>
#import "DBDUIViewTools.h"
#import "UIButton_DBDAdditions.h"
#import "AVAudioPlayer_DBDAdditions.h"

@interface aMMMakeupController (aMMMakeupController_hidden)
-(void) displayHalfTableViewForProperty:(NSString*)key;  //implemented by subclass
@end

@implementation aMMMakeupController
@synthesize product;
@synthesize brand;
@synthesize formula;
@synthesize color;
@synthesize backButton;
@synthesize hiddenButton;
@synthesize halfTableView;
@synthesize halfTableController;


- (void)dealloc {
	[product release];
	[brand release];
	[formula release];
	[color release];
	
	[backButton release];
	
	[hiddenButton release];	
	[halfTableView release];
	[halfTableController release];

	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
    [super dealloc];
}

-(IBAction) backButtonPressed{
	[self.navigationController popViewControllerAnimated:YES];
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
	
	self.halfTableController = [[aMMHalfTableController alloc] init];
	self.halfTableController.key = nil;
	self.halfTableController.observer = self;
	halfTableView.delegate = halfTableController;
	halfTableView.dataSource = halfTableController;
	halfTableView.hidden = YES;
	halfTableView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:halfTableView];
	
	[self.backButton applyGlossColor:UIButtonColorBlue forState:UIControlStateNormal];
	
	product.delegate = self;
	brand.delegate = self;
	formula.delegate = self;
	color.delegate = self;
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

-(NSDictionary*)additionalPredicatesDictionary{
	//again, fill the additional predicates with any textfield ivar in this class.
	NSMutableDictionary *additionalPredicates = [[[NSMutableDictionary alloc] init] autorelease];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([aMMMakeupController class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		if ([object_getIvar(self, thisIvar) isKindOfClass:[UITextField class]]){
			if (![[(UITextField*)object_getIvar(self, thisIvar) text] isEqualToString:@""]){[additionalPredicates setObject:[(UITextField*)object_getIvar(self, thisIvar) text] forKey:[NSString stringWithUTF8String:ivar_getName(thisIvar)]];}	
		}
	}
	free(ivars);
	return additionalPredicates;
}

-(NSArray*) textFields{return nil;} //defined in category
-(IBAction) hiddenButtonPress{;} //defined in category
@end

@implementation aMMMakeupController (aMMMakeupController_hidden)

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	[AVAudioPlayer playResouce:@"Click" ofType:@"wav"];
	
	NSString * key = nil;
	textField.text = @"";
	
	//runtime hacking to get the name of the ivar, which will also be the name of the key a-la Ruby On Rails
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([aMMMakeupController class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		if (object_getIvar(self, thisIvar) == textField){
			key = [NSString stringWithUTF8String:ivar_getName(thisIvar)];
			break;
		}
	}
	free(ivars);
	
	[self displayHalfTableViewForProperty:key];
	return NO;
}

-(void) displayHalfTableViewForProperty:(NSString*)key{
	//method stub, ment to be implemented in subclass.
}

-(IBAction) hiddenButtonPress{
	if (CGRectContainsRect(self.view.frame, halfTableView.frame) && !halfTableView.hidden){
		[AVAudioPlayer playResouce:@"ClickReverse" ofType:@"wav"];
	
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration:0.5];
		if (halfTableView.frame.origin.y == self.view.bounds.origin.y)
			[halfTableView setFrameOriginY:self.view.bounds.origin.y - halfTableView.frame.size.height];
		else
			[halfTableView setFrameOriginY:self.view.bounds.size.height];
		[UIView commitAnimations];
	}
}

-(void) tableValueSelected:(NSString*)value forKey:(NSString*)key{//table controller delegate
	//I can see that I'm going to end up putting this RoR stuff into a method
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([aMMMakeupController class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		if ([object_getIvar(self, thisIvar) isKindOfClass:[UITextField class]]){
			if([[NSString stringWithUTF8String:ivar_getName(thisIvar)] isEqualToString:key]){
				[(UITextField*)object_getIvar(self, thisIvar) setText:value];
				break;
			}
		}
	}
	free(ivars);
	
	// A little to much automation...kinda confuses the user.
	//	if([key isEqualToString:@"product"])
	//		[brand becomeFirstResponder];
	//	else if([key isEqualToString:@"brand"])
	//		[formula becomeFirstResponder];
	//	else if([key isEqualToString:@"formula"])
	//		[color becomeFirstResponder];
	//	else if([key isEqualToString:@"color"])
	[self hiddenButtonPress];
}

-(NSArray*) textFields{
	NSMutableArray *textFields = [[[NSMutableArray alloc] init] autorelease];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([aMMMakeupController class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		if ([object_getIvar(self, thisIvar) isKindOfClass:[UITextField class]]){
			[textFields addObject:object_getIvar(self, thisIvar)];
		}
	}
	free(ivars);
	return textFields;
}

@end
