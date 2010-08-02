//
//  UIUsernamePasswordDialog.m
//  itryiton
//
//  Created by Mark Lorenz on 11/27/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "UIUsernamePasswordDialog.h"


@implementation UIUsernamePasswordDialog
@synthesize usernameField;
@synthesize passwordField;

- (void)dealloc {
	[usernameField release];
	[passwordField release];
	
	[super dealloc];
}
-(id) initAsUnameAndPassTypeWithTitle:(NSString*)title delegate:(id)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitle:(NSString*)otherButtonTitle{
	self = [super initWithTitle:title message:@"\n \n \n" delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
	
	CGRect initFrame = self.frame;
	CGRect firstTextFrame = CGRectMake(12.0, 45.0, 260.0, 25.0);
	CGRect secondTextFrame = CGRectMake(firstTextFrame.origin.x, firstTextFrame.origin.y+firstTextFrame.size.height+kUIUsernamePasswordDialogBumper, firstTextFrame.size.width, firstTextFrame.size.height);
	UITextField *unameText = [[UITextField alloc] initWithFrame:firstTextFrame];
	UITextField *passText = [[UITextField alloc] initWithFrame:secondTextFrame];
	
	unameText.placeholder = @"User Name";
	passText.placeholder = @"Password";
	
	unameText.backgroundColor = [UIColor clearColor];
	passText.backgroundColor = [UIColor clearColor];
	unameText.borderStyle = UITextBorderStyleRoundedRect;
	passText.borderStyle = UITextBorderStyleRoundedRect;
	
	unameText.keyboardAppearance = UIKeyboardAppearanceDefault;
	passText.keyboardAppearance = UIKeyboardAppearanceDefault;
	unameText.autocapitalizationType = UITextAutocapitalizationTypeNone;
	passText.autocapitalizationType = UITextAutocapitalizationTypeNone;
	passText.secureTextEntry = YES;
	
	[self addSubview:unameText];
	[self addSubview:passText];
	self.usernameField = unameText;
	self.passwordField = passText;
	
	[unameText release];
	[passText release];  
	
	CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 130.0); 
	[self setTransform:translate];
	
	return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // Initialization code
    }
    return self;
}

-(void) show{
	[self.usernameField becomeFirstResponder];

	[super show];
}
//- (void)drawRect:(CGRect)rect {
    // Drawing code
//}





@end
