//
//  aMMMainViewController.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 25-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#import <UIKit/UIKit.h>

#define ML_DEBUG(x) ;  // "ML_DEBUG(x) ;"  -sliences dealloc logging  "ML_DEBUG(x) (x)" activates dealloc logging

@class DBDScoobyView;
@class DBDShakeResponder;
@interface aMMMainViewController : UIViewController {
	IBOutlet UIButton *buySellButton;
	IBOutlet UIButton *findButton;
	IBOutlet UIButton *aboutThisAppButton;
	
	IBOutlet DBDScoobyView *drinkMeScrollView;
	IBOutlet UIButton *drinkMeButton;
	DBDShakeResponder *shakeResponder;
}

@property (nonatomic, retain)  UIButton *buySellButton;
@property (nonatomic, retain)  UIButton *findButton;
@property (nonatomic, retain)  UIButton *aboutThisAppButton;
@property (nonatomic, retain) DBDScoobyView *drinkMeScrollView;
@property (nonatomic, retain) UIButton *drinkMeButton;

-(IBAction) buySellButtonPressed;
-(IBAction) findButtonPressed;
-(IBAction) aboutThisAppButtonPressed;
-(IBAction) hiddenButtonPress;

@end

/* -- Revision History --
 v0.0	25-Apr-2010	Change Points: New File
 
 */