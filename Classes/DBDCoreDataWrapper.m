//
//  DBDCoreDataWrapper.m
//  iTheeWed
//
//  Created by Mark Lorenz on 2/20/10.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "DBDCoreDataWrapper.h"


@implementation DBDCoreDataWrapper

+ (NSManagedObjectContext*)managedObjectContext{
	return [[[UIApplication sharedApplication] delegate] managedObjectContext];
}

+ (NSArray*) fetchEntitiesOfType:(NSString*)entityName{
	NSManagedObjectContext *moc = [[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:moc];
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
	[request setEntity:entityDescription];
	
	NSError *error = nil;
	NSArray *array = [moc executeFetchRequest:request error:&error];
	if (array == nil){
		NSLog(@"there was an error fetching: %@", entityName);
		NSLog(error.localizedDescription);
	}
	
	return array;
} 

+ (id) insertEntityOfType:(NSString*)entityType withAttribuites:(NSDictionary*)attributes saveContext:(BOOL)save{
	NSManagedObjectContext *moc = [[[UIApplication sharedApplication] delegate] managedObjectContext];
	id entity = [NSEntityDescription insertNewObjectForEntityForName:entityType inManagedObjectContext:moc];
	
	for (NSString *key in [attributes allKeys]){
		[entity setValue:[attributes objectForKey:key] forKey:key];
	}
	
	if (save) {
		NSError *error;
		if (![moc save:&error]) {
			NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
			if(detailedErrors != nil && [detailedErrors count] > 0) {
				for(NSError* detailedError in detailedErrors) {
					NSLog(@"  DetailedError: %@", [detailedError userInfo]);
				}
			}
			else {
				NSLog(@"  %@", [error userInfo]);
			}
		}
	}
	return entity;
}

+ (NSError*) forceContextSave{
	NSManagedObjectContext *moc = [[[UIApplication sharedApplication] delegate] managedObjectContext];
	NSError *error = nil;
	if (![moc save:&error]) {
		NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		if(detailedErrors != nil && [detailedErrors count] > 0) {
			for(NSError* detailedError in detailedErrors) {
				NSLog(@"  DetailedError: %@", [detailedError userInfo]);
			}
		}
		else {
			NSLog(@"  %@", [error userInfo]);
		}
	}
	return error;
}



@end

@implementation DBDCoreDataWrapper (DBDCoreDataWrapper_hidden)


@end