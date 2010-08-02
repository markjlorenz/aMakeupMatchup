//
//  aMMAllMatchingOptionsTableController.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 26-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface aMMAllMatchingOptionsTableController : UITableViewController {
	NSMutableArray *matchingMakeup;
	BOOL canDelete;
}
@property (nonatomic, retain) NSMutableArray *matchingMakeup;
@property (nonatomic, assign) BOOL canDelete;
@end
