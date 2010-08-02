//
//  AppInfo.h
//  BeerTemperature
//
//  Created by Mark Lorenz on 5/28/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
// To return from the app info view, you can implement the delegate method "shouldCloseInfo"
// i.e:
//-(void)shouldCloseInfo:(BOOL)willClose{
//	if (willClose)
//		[self switchToView:self.menu direction:kDirectionBackward];
//}

#import <UIKit/UIKit.h>
#import "TweetPoster.h"
#import <CoreGraphics/CoreGraphics.h>
#import "MLAppTipBubbleView.h"
#import "MLNetFetchImageView.h"
#import "DBDScoobyView.h"
#import "DBDGeneralMacros.h"

#define IB_OBJECT_OFFSET  5.0
#define ALLOWED_TWEET_CHARS 140


@interface AppInfo : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>{
	IBOutlet UITextView *tweetText;
	IBOutlet UIImageView *tweetTextBackground;
	IBOutlet UILabel	*tweetCharsRemainingLable;
	IBOutlet UIButton	*tweetButton;
	IBOutlet UIButton	*keyBoardCloseButton;
	IBOutlet UISwitch	*tipBubblesToggle;
	IBOutlet UIImageView *companyLogo;
	IBOutlet UILabel	*revNo;
	IBOutlet UILabel	*companyName;
	IBOutlet UIButton	*visitOurWebSite;
	IBOutlet UIButton	*promotionalLink;
	IBOutlet UILabel	*tweetTitle;
	IBOutlet DBDScoobyView *scoobyView;
	
	IBOutlet UILabel	*promotionalLabel1;
	IBOutlet UILabel	*promotionalLabel2;
	IBOutlet UILabel	*promotionalLabel3;
	IBOutlet UIImageView *promotionalImage;
	
	TweetPoster *tweetPoster;
	
	
	
	CGRect keyboardBounds;
	CGRect tweetTextStartPosition;
	CGRect tweetCharsRemainingLableStartPosition;
	CGRect tweetTitleStartPosition;

	UIColor *tweetCharsRemainingColor;
	
	id appInfoDelegate;
	BOOL navigationBarHidesSaveState;
}

@property (nonatomic, retain) UITextView *tweetText;
@property (nonatomic, retain) UIImageView *tweetTextBackground;
@property (nonatomic, retain) UILabel *tweetCharsRemainingLable;
@property (nonatomic, retain) UIButton *tweetButton;
@property (nonatomic, retain) UIButton *promotionalLink;
@property (nonatomic, retain) UISwitch *tipBubblesToggle;
@property (nonatomic, retain) TweetPoster *tweetPoster;
@property (nonatomic, retain) DBDScoobyView *scoobyView;

@property (nonatomic, retain) IBOutlet UILabel	*promotionalLabel1;
@property (nonatomic, retain) IBOutlet UILabel	*promotionalLabel2;
@property (nonatomic, retain) IBOutlet UILabel	*promotionalLabel3;
@property (nonatomic, retain) IBOutlet UIImageView *promotionalImage;


@property (assign) id appInfoDelegate;
-(void)shouldCloseInfo:(BOOL)willClose sender:(id)sender;


-(IBAction) tweetButtonPressed;
-(IBAction) keyboardCloseButton;
-(IBAction) promotinalLinkPressed;
-(IBAction) backButton;
-(IBAction) toggleTipBubbles;
-(IBAction) launchSafari;

-(void)fadeOutView:(UIView *)view;
-(void)fadeInView:(UIView *)view;
@end
