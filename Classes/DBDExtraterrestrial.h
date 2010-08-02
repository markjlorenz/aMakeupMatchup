//
//  DBDExtraterrestrial.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 1-May-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#import <Foundation/Foundation.h>

#define ML_DEBUG(x) ;  // "ML_DEBUG(x) ;"  -sliences dealloc logging  "ML_DEBUG(x) (x)" activates dealloc logging

//@protocol <#protocol#>
//
//<#methods#>
//
//@end

@interface DBDExtraterrestrial : NSObject {

}
+(void) phoneHomeWithKeys:(NSArray*)keys values:(NSArray*)values toPage:(NSString*)URL;
@end

/* -- Revision History --
 v0.0	1-May-2010	Change Points: New File
 
*/
