//
//  DBDNetFetchTextView.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 11-May-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#import <UIKit/UIKit.h>

#define ML_DEBUG(x) ;  // "ML_DEBUG(x) ;"  -sliences dealloc logging  "ML_DEBUG(x) (x)" activates dealloc logging

//@protocol <#protocol#>
//
//<#methods#>
//
//@end

@interface DBDNetFetchTextView : UITextView {
	NSMutableData *_data;
	NSURLConnection *_connection;
	NSString *_URL;
	BOOL isCancelled;
	UIActivityIndicatorView *networkActivity;
}
@property (nonatomic, retain, setter=setURL, getter = URL) NSString *_URL;
-(void) fetchFeed;
-(void) cancel;
@end

/* -- Revision History --
 v0.0	11-May-2010	Change Points: New File
 
 */