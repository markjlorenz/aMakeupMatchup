//
//  TweetPoster.h
//  BeerTemperature
//
//  Created by Mark Lorenz on 5/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIUsernamePasswordDialog.h"

#define kTwitterTweetLimit 139

#define kUserDefaultUsernameKey (@"username")
#define kUserDefaultPasswordKey (@"password")

enum{
	kUserNameAlert,
	kPasswordAlert
};

@class TweetPoster;
@protocol TweetPosterDelegate
@optional
-(void)tweetPoster:(TweetPoster*)tweetPoster didPost:(BOOL)successfully;
@end

@interface TweetPoster : NSObject <UITextFieldDelegate> {
	NSString *hashTag;
	NSString *userName;
	NSString *password;
	NSString *tweet;

	id delegate;
}

@property (retain, nonatomic) NSString *hashTag;
@property (retain, nonatomic) NSString *userName;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSString *tweet;
@property (assign) id delegate;

-(void) getUsernameAndPasswordThenPost;
-(void) postTweet;
- (NSString*) tweetCharacterOverrunFix;
- (BOOL) tweetCharacterIsOverrun;
-(NSInteger)tweetCharactersRemaining: (NSString *)Partialtweet;


-(NSString *)getTweetText;
@end
