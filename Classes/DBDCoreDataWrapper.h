//
//  DBDCoreDataWrapper.h
//  iTheeWed
//
//  Created by Mark Lorenz on 2/20/10.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate_DBDAdditions.h"

#define ML_DEBUG(x) ;  // "ML_DEBUG(x) ;"  -sliences dealloc logging  "ML_DEBUG(x) (x)" activates dealloc logging

//@protocol <#protocol#>
//
//<#methods#>
//
//@end

@interface DBDCoreDataWrapper : NSObject {

}

+ (NSArray*) fetchEntitiesOfType:(NSString*)entityName;
+ (id) insertEntityOfType:(NSString*)entityType withAttribuites:(NSDictionary*)attributes saveContext:(BOOL)save; //returns autoreleased entity
+ (NSError*) forceContextSave;
+ (NSManagedObjectContext*)managedObjectContext;

@end
	
@interface DBDCoreDataWrapper (DBDCoreDataWrapper_hidden)

@end


/* -- Revision History --
 v0.0	??-???-????	Change Points: New File
 v0.1	25-Apr-2010	Change Points: manaagedObjectContext convenience method added
 
 */