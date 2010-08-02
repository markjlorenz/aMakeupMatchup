//
//  aMMBuySellMakeupController.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 25-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "aMMBuySellMakeupController.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "DBDCoreDataWrapper.h"
#import "UIButton_DBDAdditions.h"
#import "DBDGeneralMacros.h"
#import "DBDUIViewTools.h"
#import "Makeup_Additions.h"
#import "AVAudioPlayer_DBDAdditions.h"


//taking a short cut
#import "aMMFindMakeupController.h"
#import "aMMHalfTableController.h"

@interface aMMBuySellMakeupController (aMMBuySellMakeupController_hidden)
-(CGPoint) focusPointForText:(UITextField*)textField;
-(void) bringTextFieldIntoFocus:(UITextField*)textField;
-(void) throwView:(UIView*)view;
@end

@implementation aMMBuySellMakeupController
@synthesize buyButton;
//@synthesize sellButton;


- (void)dealloc {
	[buyButton release];
//	[sellButton release];
	
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
    [super dealloc];
}

-(IBAction) buyButtonPressed{
	aMMHalfTableController *halfTableContoller = [[aMMHalfTableController alloc] init];
	halfTableContoller.key = @"product";
	halfTableContoller.additionalPredicateKeysAndValues = [self additionalPredicatesDictionary];
	
	BOOL textEntered = NO;
	for (UITextField *textField in [self textFields]){
		if (textField.text.length){
			textEntered = YES;
			break;
		}
	}
	if (!textEntered){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:DBDLocalizedString(@"Nothing Entered!")
														message:DBDLocalizedString(@"To add makeup you need to enter at least a product name.")
													   delegate:nil
											  cancelButtonTitle:DBDLocalizedString(@"Ok")
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	else if (!product.text.length){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:DBDLocalizedString(@"No Product Type!")
														message:DBDLocalizedString(@"To add makeup you need to enter a product type.")
													   delegate:nil
											  cancelButtonTitle:DBDLocalizedString(@"Ok")
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	else if ([[halfTableContoller objectsForSource] count]){
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:DBDLocalizedString(@"Duplicate Makeup")
														message:DBDLocalizedString(@"You already have that makeup in your bag.")
													   delegate:nil
											  cancelButtonTitle:DBDLocalizedString(@"Ok")
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	
	else{
		NSDictionary *newMakeupAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
											  [NSDate serializedDateString], @"makeupId",
											 product.text, @"product",
											  brand.text, @"brand",
											  formula.text, @"formula",
											  color.text, @"color",
											  nil];
		
		Makeup *makeup = [DBDCoreDataWrapper insertEntityOfType:@"Makeup" withAttribuites:newMakeupAttributes saveContext:YES];
		[makeup phoneHome];
		
		
		UIImageView *flyingView = nil;
		NSArray *imageOptions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"product" ofType:@"plist"]];		
		for (NSString *imageName in imageOptions){
			if ([product.text isEqualToString:imageName]){
				flyingView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]]];
				break;
			}
		}
		if (!flyingView)
			flyingView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Other" ofType:@"png"]]];
		
		[self.view insertSubview:flyingView belowSubview:[self.view viewWithTag:2]]; //the top flap view identified in IB.
		[self throwView:flyingView];
		[flyingView release];		
	}
}

-(void) throwView:(UIView*)view{
	CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	animation.delegate = nil;
	CGMutablePathRef path = CGPathCreateMutable();
	NSDictionary *bezierCurve = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"FlyingMakeupPath" ofType:@"plist"]];
	[view setFrameOrigin:CGPointMake([[bezierCurve objectForKey:@"mx"] floatValue], [[bezierCurve objectForKey:@"my"] floatValue])];
	CGPathMoveToPoint(path, NULL, view.frame.origin.x, view.frame.origin.y);
	CGPathAddCurveToPoint(path, nil, [[bezierCurve objectForKey:@"cp1x"] floatValue], [[bezierCurve objectForKey:@"cp1y"] floatValue], [[bezierCurve objectForKey:@"cp2x"] floatValue], [[bezierCurve objectForKey:@"cp2y"] floatValue], [[bezierCurve objectForKey:@"x"] floatValue], [[bezierCurve objectForKey:@"y"] floatValue]);
	animation.timingFunctions = [NSArray arrayWithObject:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
	animation.path = path;
	animation.duration = 1.5;
	[view.layer addAnimation:animation forKey:@"flying_makeup"];
	CGPathRelease(path);
	
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.0];																																														 
		view.bounds = CGRectMake(0.0, 0.0, 41, 33);
	[UIView commitAnimations];
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
	CGFloat tableHeight = 150.0;
	halfTableView.frame = CGRectMake(0.0, self.view.bounds.origin.y - tableHeight, self.view.bounds.size.width, tableHeight);
	halfTableView.hidden = NO;
	
	[self.buyButton applyGlossColor:UIButtonColorPink forState:UIControlStateNormal];
	//[self.sellButton applyGlossColor:UIButtonColorRed forState:UIControlStateNormal];
	
	focusView = nil;
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
	NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(keyboardMoved:) name: UIKeyboardWillShowNotification object:nil];
//	[nc addObserver:self selector:@selector(keyboardMoved:) name: UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
	[super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) keyboardMoved:(NSNotification *) note{
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	
    CGRect t;
    [[note.userInfo valueForKey:UIKeyboardBoundsUserInfoKey] getValue: &t];
    [halfTableView setFrameOriginY:[[UIScreen mainScreen] applicationFrame].size.height - t.size.height - halfTableView.bounds.size.height];
	
	[UIView	 commitAnimations];
}

-(IBAction) hiddenButtonPress{
	if (CGRectContainsRect(self.view.frame, halfTableView.frame)  && !halfTableView.hidden){
		[AVAudioPlayer playResouce:@"ClickReverse" ofType:@"wav"];
//	[super hiddenButtonPress]; //super hides the view
		[self textFieldShouldReturn:focusView];
	}
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

@implementation aMMBuySellMakeupController (aMMBuySellMakeupController_hidden)

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
	self.halfTableController.autocompletePartial = nil; //clear it out incase it was set earlier
	[self bringTextFieldIntoFocus: textField];
	[super textFieldShouldBeginEditing:textField]; //super will handle the 1/2table view
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self bringTextFieldIntoFocus:nil];
	
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
	[halfTableView setFrameOriginY:self.view.bounds.origin.y - halfTableView.bounds.size.height];
	[UIView commitAnimations];
	
	return [super textFieldShouldReturn:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
	NSMutableString *textFieldText = [NSMutableString stringWithString:textField.text];
	[textFieldText replaceCharactersInRange:range withString:string];
	self.halfTableController.autocompletePartial = textFieldText;
	[self.halfTableView reloadData];
	return YES;
}

-(CGPoint) focusPointForText:(UITextField*)textField{
	return CGPointMake(self.view.bounds.size.width/2.0, kaMMBuySellMakeupControllerEdgeBuffer+textField.bounds.size.height/2.0);
}

-(void) bringTextFieldIntoFocus:(UITextField*)textField{	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	//put the old one back
	focusView.frame = movedViewStartFrame;
	movedViewStartFrame = textField.frame;
	focusView = textField;
	
	//bring the new one ups
	[textField setBoundsWidth:self.view.bounds.size.width - kaMMBuySellMakeupControllerEdgeBuffer*2.0];
	textField.center = [self focusPointForText:textField];
	[UIView commitAnimations];
	
}

-(void) displayHalfTableViewForProperty:(NSString*)key{
	halfTableController.key = key;
	
	halfTableController.additionalPredicateKeysAndValues = [super additionalPredicatesDictionary];
	halfTableController.prefillOptions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:key ofType:@"plist"]];
	[halfTableView reloadData];
	
//	halfTableView.hidden = NO;
//	[UIView beginAnimations:nil context:nil];
//	[UIView setAnimationDuration:0.5];
//	[halfTableView setFrameOriginY:screenHalf];
//	[UIView commitAnimations];
}

-(NSDictionary*)additionalPredicatesDictionary{
	//again, fill the additional predicates with any textfield ivar in this class.
	NSMutableDictionary *additionalPredicates = [[[NSMutableDictionary alloc] init] autorelease];
	unsigned int numIvars = 0;
	Ivar * ivars = class_copyIvarList([aMMMakeupController class], &numIvars);
	for(int i = 0; i < numIvars; i++) {
		Ivar thisIvar = ivars[i];
		if ([object_getIvar(self, thisIvar) isKindOfClass:[UITextField class]]){
			[additionalPredicates setObject:[(UITextField*)object_getIvar(self, thisIvar) text] forKey:[NSString stringWithUTF8String:ivar_getName(thisIvar)]];	
		}
	}
	free(ivars);
	return additionalPredicates;
}


@end
