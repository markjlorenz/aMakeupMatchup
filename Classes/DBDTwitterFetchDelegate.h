//
//  DBDTwitterFetchDelegate.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 7-May-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#import <Foundation/Foundation.h>

#define ML_DEBUG(x) ;  // "ML_DEBUG(x) ;"  -sliences dealloc logging  "ML_DEBUG(x) (x)" activates dealloc logging

//twitter JSON API keys
#define kDBDTwitterFetchDelegate_TwitterAPIFromUserKey @"from_user"
#define kDBDTwitterFetchDelegate_TwitterAPITweetsKey @"results"
#define kDBDTwitterFetchDelegate_TwitterAPITweetTextKey @"text"
#define kDBDTwitterFetchDelegate_TwitterAPIUserImageURL @"profile_image_url"
#define kDBDTwitterFetchDelegate_TwitterAPITweetDate @"created_at"
#define kDBDTwitterFetchDelegate_FetchURL_1 @"http://search.twitter.com/search.json?q=%23"
#define kDBDTwitterFetchDelegate_FetchURL_2 @"&rpp="

@class DBDTwitterFetchDelegate;
@protocol DBDTwitterFetchDelegateController
@optional
-(void)twitterFetchDelegate:(DBDTwitterFetchDelegate*)delegate fetchedArray:(NSArray*)array;
-(void)twitterFetchDelegate:(DBDTwitterFetchDelegate*)delegate fetchedImages:(NSDictionary*)usernamesAndImages;
-(void)twitterFetchDelegateFailedOnImages:(NSArray*)arg;
@end

@interface DBDTwitterFetchDelegate : NSObject {
	NSMutableData *_data;
	id _controller;
	NSString *_hash;
	NSUInteger responseLimit;
	NSDictionary *_existingImages;
	NSURLConnection *_connection;
	
	BOOL backgroundIsCancelled;
}
@property (nonatomic, assign, getter=controller, setter=setController) id _controller; 
@property (nonatomic, retain, getter=hash, setter=setHash) NSString *_hash;
@property (nonatomic, assign) NSUInteger responseLimit;

-(id) initWithController:(id)controller hashTag:(NSString*)hash;
-(void) fetchFeed;
-(void)fetchTwitterIcons:(NSArray*)JSONTweets existingImages:(NSDictionary*)usernamesAndImageURLs;
-(void) cancel;
@end

/* -- Revision History --
 v0.0	7-May-2010	Change Points: New File
 
*/
