//
//  aMakeupMatchupAppDelegate.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 24-Apr-2010.
//  Copyright Dapple Before Dawn 2010. All rights reserved.
//

@interface aMakeupMatchupAppDelegate : NSObject <UIApplicationDelegate> {

    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;

    UIWindow *window;
	UINavigationController *navigationController;
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;

- (NSString *)applicationDocumentsDirectory;

@end

