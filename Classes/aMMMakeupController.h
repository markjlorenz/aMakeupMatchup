//
//  aMMMakeupController.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 28-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file
//
//  Semi-abstract class, subclass should implement: -(void) displayHalfTableViewForProperty:(NSString*)key
//	if they wish to display the 1/2 table view
//

#import <UIKit/UIKit.h>

#define ML_DEBUG(x) ;  // "ML_DEBUG(x) ;"  -sliences dealloc logging  "ML_DEBUG(x) (x)" activates dealloc logging

@class aMMHalfTableController;
@interface aMMMakeupController : UIViewController <UITextFieldDelegate>{
	IBOutlet UITextField *product;
	IBOutlet UITextField *brand;
	IBOutlet UITextField *formula;
	IBOutlet UITextField *color;

	IBOutlet UIButton *backButton;
	IBOutlet UIButton *hiddenButton;	

	IBOutlet UITableView *halfTableView;
	IBOutlet aMMHalfTableController *halfTableController;
	
}
@property (nonatomic, retain) IBOutlet UITextField *product;
@property (nonatomic, retain) IBOutlet UITextField *brand;
@property (nonatomic, retain) IBOutlet UITextField *formula;
@property (nonatomic, retain) IBOutlet UITextField *color;

@property (nonatomic, retain) UIButton *hiddenButton;
@property (nonatomic, retain) UIButton *backButton;
@property (nonatomic, retain) UITableView *halfTableView;
@property (nonatomic, retain) aMMHalfTableController *halfTableController;

-(IBAction) hiddenButtonPress;
-(IBAction) backButtonPressed;
-(NSDictionary*)additionalPredicatesDictionary;
-(NSArray*) textFields;

@end

/* -- Revision History --
 v0.0	28-Apr-2010	Change Points: New File
 
 */