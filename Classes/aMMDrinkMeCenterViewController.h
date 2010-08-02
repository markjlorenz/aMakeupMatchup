//
//  aMMDrinkMeCenterViewController.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 7-May-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#import <UIKit/UIKit.h>

#define ML_DEBUG(x) ;  // "ML_DEBUG(x) ;"  -sliences dealloc logging  "ML_DEBUG(x) (x)" activates dealloc logging

@class DBDTwitterSearchTableController;
@class TweetPoster;
@class DBDTiledView;
@class DBDNetFetchTextView;
@class aMMHiddenCombinationDelegate;
@interface aMMDrinkMeCenterViewController : UIViewController {
	IBOutlet UIImageView *twitterFeedBackground;
	IBOutlet UIImageView *tweetTextBackground;
	IBOutlet UITableView *twitterFeed;
	IBOutlet UITextView *tweetText;
	IBOutlet UIButton *tweetButton;
	IBOutlet UIButton *hiddenButton;
	IBOutlet UIButton *questionButton;
	IBOutlet UILabel *tweetCharactersRemaining;
	IBOutlet UILabel *tweetCharactersRemainingHeading;
	IBOutlet DBDTiledView *tileView;
	IBOutlet DBDNetFetchTextView *conversationStarterText;
	
	IBOutlet UIView *combinationContainer;
	IBOutlet UIPickerView *combination;
	IBOutlet UIButton *unlockButton;
	aMMHiddenCombinationDelegate *combinationDelegate;
	
	DBDTwitterSearchTableController *twitterFeedController;
	
	CGRect tweetTextStartingFrame;
	UIColor *tweetCharactersRemainingColor;
	CGFloat tweetTextSmallFontSize;
	NSString *tweetPlaceholderText;
	UIColor *tweetPlaceholderTextColor;
	
	TweetPoster *twitterPostContoller;
}

@property (nonatomic, retain) UIImageView *twitterFeedBackground;
@property (nonatomic, retain) UIImageView *tweetTextBackground;
@property (nonatomic, retain) UITableView *twitterFeed;
@property (nonatomic, retain) UITextView *tweetText;
@property (nonatomic, retain) UIButton *tweetButton;
@property (nonatomic, retain) UIButton *hiddenButton;
@property (nonatomic, retain) UIButton *questionButton;
@property (nonatomic, retain) UILabel *tweetCharactersRemaining;
@property (nonatomic, retain) UILabel *tweetCharactersRemainingHeading;
@property (nonatomic, retain) DBDTiledView *tileView;
@property (nonatomic, retain) DBDNetFetchTextView *conversationStarterText;
@property (nonatomic, retain) DBDTwitterSearchTableController *twitterFeedController;
@property (nonatomic, retain) UIColor *tweetCharactersRemainingColor;
@property (nonatomic, retain) NSString *tweetPlaceholderText;
@property (nonatomic, retain) UIColor *tweetPlaceholderTextColor;

@property (nonatomic, retain) UIView *combinationContainer;
@property (nonatomic, retain) UIPickerView *combination;
@property (nonatomic, retain) UIButton *unlockButton;

-(IBAction) tweetButtonPressed;
-(IBAction) hiddenButtonPressed;
-(IBAction) questionButtonPressed;
-(IBAction) unlockButtonPressed;

@end

/* -- Revision History --
 v0.0	7-May-2010	Change Points: New File
 
 */