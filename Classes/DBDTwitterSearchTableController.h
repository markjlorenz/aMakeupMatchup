//
//  DBDTwitterSearchTableController.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 7-May-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#import <Foundation/Foundation.h>

#define  ML_DEBUG(x) ;  // "ML_DEBUG(x) ;"  -sliences dealloc logging  "ML_DEBUG(x) (x)" activates dealloc logging

//@protocol <#protocol#>
//
//<#methods#>
//
//@end

@class DBDTwitterFetchDelegate;
@interface DBDTwitterSearchTableController : NSObject <UITableViewDelegate, UITableViewDataSource>{
	NSMutableData *twitterData;
	NSArray	 *tweets;
	NSDictionary *twitterIcons;
	UITableView *table;
	UIActivityIndicatorView *networkActivity;
	NSString *_hashTag;
	DBDTwitterFetchDelegate *activeFetchDelegate;
}
@property (nonatomic, assign) UITableView *table;
@property (nonatomic, retain, getter=hashTag, setter=setHashTag) NSString *_hashTag;

-(id) initWithTable:(UITableView*)tableview;
-(void) fetchFeed;
@end

/* -- Revision History --
 v0.0	7-May-2010	Change Points: New File
 
*/
