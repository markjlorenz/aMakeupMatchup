//
//  MLRateMeReminder.h
//  itryiton
//
//  Created by Mark Lorenz on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//
// data struture for the saved data:
// objectAtIndex:0 - an NSNumber the number of times the app has been opened
// objectAtIndex:1 - an NSNumber 1 means ask the user to rate, 0 means don't

#import <Foundation/Foundation.h>
#define promptAfter_Times (5) //after this number of times the app will prompt for reviews

enum  { //if you change this layout you need to update dismissAnimation
	MLRateMeReminder10xAlert,
	MLRateMeReminder50xAlert
};

@interface MLRateMeReminder : NSObject <UIAlertViewDelegate>{
	NSUInteger numberTimesOpened;
	NSUInteger mayPrompt;
	
	NSString *appStorePointer;
}

@property (nonatomic, retain) NSString *appStorePointer;

+ (MLRateMeReminder*)executeRemiderWithURLPointer:(NSString*)appStoreURLPointerURL;
-(id) initAndExecute:(NSString*)appStoreURLPointerURL;
-(void) resetToFactory;
	
@end
