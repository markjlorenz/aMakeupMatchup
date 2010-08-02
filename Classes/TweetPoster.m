//
//  TweetPoster.m
//  BeerTemperature
//
//  Created by Mark Lorenz on 5/26/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
// portions of this file NOT actually written by me, but it was heavly modified and debugged to the point where it
// doesn't resemble the origional too much.

#import "TweetPoster.h"
#import "NSString_DBDAdditions.h"

@implementation TweetPoster
@synthesize hashTag;
@synthesize userName;
@synthesize password;
@synthesize tweet;
@synthesize delegate;

-(id) init{
	hashTag = @" #aMakeupMatchup";
	return self;
}

-(void) getUsernameAndPasswordThenPost{
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; //load the user defaults
	
	UIUsernamePasswordDialog *uname_passAlert = [[UIUsernamePasswordDialog alloc] initAsUnameAndPassTypeWithTitle:@"Twitter Account Information"
																										 delegate:self
																								cancelButtonTitle:@"Cancel"
																								 otherButtonTitle:@"OK"];
	if ([[defaults objectForKey:kUserDefaultUsernameKey] length])
		uname_passAlert.usernameField.text = [defaults objectForKey:kUserDefaultUsernameKey];
	else{
		//
	}
	
	if ([[defaults objectForKey:kUserDefaultPasswordKey] length])
		uname_passAlert.passwordField.text = [defaults objectForKey:kUserDefaultPasswordKey];
	else{
		//
	}

	uname_passAlert.passwordField.delegate = self;
	uname_passAlert.usernameField.delegate = self;
	uname_passAlert.tag = kUserNameAlert;  
	[uname_passAlert show];
	[uname_passAlert release];
	//method alertView will run automatically
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	// the user clicked one of the OK/Cancel buttons
	if (actionSheet.tag == kUserNameAlert){
		if (buttonIndex == 1){
			NSLog(@"ok");
			userName = [[actionSheet usernameField] text]; 
			password = [[actionSheet passwordField] text];
//			tweet = [delegate getTweetText];
			[self postTweet];
		}
		else{
			NSLog(@"cancel");
		}
	}
}

-(void) postTweet{

if (!hashTag)
	[self init];
	
// Convert the C-String arguments into Twitter-happy escaped format
NSString *unpw = [[NSString stringWithFormat:@"%@:%@", 
				   [NSString stringWithFormat:userName],
				   [NSString stringWithFormat:password]]
				  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//NSString *sanitizedTweet = [tweet stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSString *sanitizedTweet = [tweet replaceDumbTwitterChars];
	
NSString *body = [NSString stringWithFormat:@"source=&status=%@ %@", sanitizedTweet, hashTag];

// Establish the Twitter API request
id baseurl = [NSString stringWithFormat:
			  @"http://%@@twitter.com/statuses/update.xml", unpw];
NSURL *url = [NSURL URLWithString:baseurl];
NSMutableURLRequest *urlRequest = [NSMutableURLRequest
								   requestWithURL:url];

if (!urlRequest)
{
	printf("Error creating URL Request. Exiting.\n");
}

[urlRequest setHTTPMethod: @"POST"];
[urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
[urlRequest setValue:@"application/x-www-form-urlencoded"
  forHTTPHeaderField:@"Content-Type"];
//[urlRequest setValue:@"" forHTTPHeaderField:@"X-Twitter-Client"];


NSError *error;
NSURLResponse *response;
NSData* result = [NSURLConnection sendSynchronousRequest:urlRequest
									   returningResponse:&response error:&error];
	BOOL successfully = NO;
if (!result)
{
	printf("Submission Error : %s\n", [[error localizedDescription] UTF8String]);
	
	NSString *errorMessage = [[NSString alloc] initWithUTF8String:[[error localizedDescription] UTF8String]];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" 
													message:errorMessage
													delegate:self 
													cancelButtonTitle: @"OK"
													otherButtonTitles:nil];
	[alert show];
	[alert release];
	[errorMessage release];
}

if (result){
// Check to see if there was an authentication error. If so, report it.
NSString *outstring = [[[NSString alloc] initWithData:result 
											 encoding:NSUTF8StringEncoding] autorelease];
	//NSLog(outstring);
if ([outstring rangeOfString:@"uthentica"].location != NSNotFound){
	printf("%s\n", [outstring UTF8String]);

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Error" 
											  message:@"Incorrect user name or password"
											  delegate:self 
											  cancelButtonTitle: @"OK"
											  otherButtonTitles:nil];
	[alert show];
	[alert release];
}
else {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" 
												message:@"Your tweet was successful"
												delegate:self 
												cancelButtonTitle: @"OK"
												otherButtonTitles:nil];
	[alert show];
	[alert release];
	}
	successfully = YES;
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults]; //load the user defaults
	if (![defaults objectForKey:kUserDefaultUsernameKey])
		[defaults setObject:userName forKey:kUserDefaultUsernameKey];
	if (![defaults objectForKey:kUserDefaultPasswordKey])
		[defaults setObject:password forKey:kUserDefaultPasswordKey];
	
	[defaults synchronize];
	
//	[outstring release];
}
	
	if ([delegate respondsToSelector:@selector(tweetPoster:didPost:)])
		[delegate tweetPoster:self didPost:successfully];
}

- (NSString*) tweetCharacterOverrunFix{
		// this method checks the length of the tweet and returns the numb of chars over the limt
		// returns origional tweet if no problem
	if(tweet.length + hashTag.length > kTwitterTweetLimit){
		NSString *shortenedTweet = [tweet substringToIndex: kTwitterTweetLimit - hashTag.length + 1];
		return shortenedTweet;
	}
	return tweet;
}

- (BOOL) tweetCharacterIsOverrun{
	// this method checks the length of the tweet and returns the numb of chars over the limt
	// returns origional tweet if no problem
	if(tweet.length + hashTag.length > kTwitterTweetLimit)
		return YES;
	return NO;
}

-(NSString *)getTweetText{
	NSLog(@"getTweetText Delegate not implemented");
	return @"";
}

-(NSInteger)tweetCharactersRemaining: (NSString *)Partialtweet{
	return (kTwitterTweetLimit - hashTag.length - Partialtweet.length);
}
@end
