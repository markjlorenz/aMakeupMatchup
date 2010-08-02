//
//  NSDate_iTWAdditions.h
//  iTheeWed
//
//  Created by Mark Lorenz on 2/21/10.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (NSDate_DBDAdditions)
+(NSString*) serializedDateString;
+ (NSString *)dateDifferenceStringFromString:(NSString *)dateString withFormat:(NSString *)dateFormat;
@end
