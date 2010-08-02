//
//  DBDStdErrLog.h
//  QRreality
//
//  Created by Mark Lorenz on 1/29/10.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// TODO: if the use tries to select something, activating the cursor, the auto-scroll behaviour breaks.  Need to either disable selection or fix.
//

#import <UIKit/UIKit.h>
//#define kDBDStdErrLogUpdateTime (1)
#define kDBDStdErrLogInitAsHeaderHeight (50.0)
#define DBDLog(format, ...) [DBDStdErrLog append:[NSString stringWithFormat:format, ## __VA_ARGS__]]; 

NSMutableSet *allConsoles;

@interface DBDStdErrLog : UITextView {
}
- (id)initAsHeader:(UIView*)superview;

+(void) append:(NSString*)text;

@end

@interface DBDStdErrLog (DBDStdErrLog_hidden)
@end

@interface UITextView (UITextView_DBDStdErrLogAdditions)
-(void) appendText:(NSString*)text;
@end