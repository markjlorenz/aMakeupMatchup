//
//  Makeup.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 25-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Makeup :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * makeupId;
@property (nonatomic, retain) NSString * product;
@property (nonatomic, retain) NSString * formula;
@property (nonatomic, retain) NSString * brand;
@property (nonatomic, retain) NSString * color;

@end



