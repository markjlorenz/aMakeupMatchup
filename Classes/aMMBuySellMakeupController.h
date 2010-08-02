//
//  aMMBuySellMakeupController.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 25-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#import <UIKit/UIKit.h>
#import "aMMMakeupController.h"

#define ML_DEBUG(x) ;  // "ML_DEBUG(x) ;"  -sliences dealloc logging  "ML_DEBUG(x) (x)" activates dealloc logging
#define kaMMBuySellMakeupControllerEdgeBuffer (20.0)

@interface aMMBuySellMakeupController : aMMMakeupController <UITextFieldDelegate>{
	UIButton *buyButton;
//	UIButton *sellButton;
	
	CGRect movedViewStartFrame;
	UITextField *focusView;
}
@property (nonatomic, retain) IBOutlet UIButton *buyButton;
//@property (nonatomic, retain) IBOutlet UIButton *sellButton;

-(IBAction) buyButtonPressed;
//-(IBAction) sellButtonPressed;


@end

/* -- Revision History --
 v0.0	25-Apr-2010	Change Points: New File
 
 */