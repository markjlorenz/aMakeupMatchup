//
//  aMMHalfTableController.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 25-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#import <Foundation/Foundation.h>
#import "DBDCoreDataWrapper.h"

#define ML_DEBUG(x) ;  // "ML_DEBUG(x) ;"  -sliences dealloc logging  "ML_DEBUG(x) (x)" activates dealloc logging

@protocol aMMHalfTableControllerObserver
@optional
	-(void) tableValueSelected:(NSString*)value forKey:(NSString*)key;
@end

@interface aMMHalfTableController : NSObject <UITableViewDelegate, UITableViewDataSource>{
	NSString *key;
	NSString *autocompletePartial;
	NSDictionary *additionalPredicateKeysAndValues; //if you want to filter the search results with a little more detail
	NSArray *prefillOptions;
	id observer;
}

@property (nonatomic, retain) NSString* key;
@property (nonatomic, retain) NSString* autocompletePartial;
@property (nonatomic, retain) NSDictionary *additionalPredicateKeysAndValues;
@property (nonatomic, retain) NSArray *prefillOptions;
@property (nonatomic, assign) NSObject *observer;

-(NSArray*) objectsForSource;
-(NSArray*) valuesWithPartialMatch:(NSString*)partial;
@end

/* -- Revision History --
 v0.0	25-Apr-2010	Change Points: New File
 
*/
