//
//  NSString_DBDAdditions.h
//  iTheeWed
//
//  Created by Mark Lorenz on 26-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//
// Revision history at the bottom of this file

#import <Foundation/Foundation.h>

@interface NSString (NSString_DBDAdditions) 
-(NSString*) stringByRemovingUnfriendlyChars;
-(NSString*) asciiSHA1digest;
-(NSString*) decodeCharacterEntityReferences;
-(NSString*) encodeCharacterEntityReferences;
-(NSString*) replaceDumbTwitterChars;

-(BOOL) isValidCurrencyCharacter;
-(NSNumber*) currencyStringToNumber;
+(NSString*) numberToCurrencyString:(NSNumber*)number;
@end

/* -- Revision History --
 v0.0	26-Apr-2010	Change Points: New File
 
*/
