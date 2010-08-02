//
//  Makeup_Additions.h
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 30-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file
#import "Makeup.h"

@interface Makeup (Makeup_Additions) 
-(void) phoneHome;

-(NSString*) digest:(NSString*)input;
-(void) postAsynchronousPHPRequest:(NSString*)request toPage:(NSString*)URL delegate:(id)delegate;
@end

/* -- Revision History --
 v0.0	30-Apr-2010	Change Points: New File
 
*/
