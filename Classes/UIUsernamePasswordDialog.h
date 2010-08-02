//
//  UIUsernamePasswordDialog.h
//  itryiton
//
//  Created by Mark Lorenz on 11/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kUIUsernamePasswordDialogBumper (12.0)
#define kTextViewHeight (31.0)

NSString * const kUIAlertViewUnameTextField;
NSString * const kUIAlertViewPassTextField;


@interface UIUsernamePasswordDialog : UIAlertView {
	UITextField *usernameField;
	UITextField *passwordField;
	
}
@property (nonatomic, retain) UITextField *usernameField;
@property (nonatomic, retain) UITextField *passwordField;
-(id) initAsUnameAndPassTypeWithTitle:(NSString*)title delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitle:(NSString*)otherButtonTitle;

@end

