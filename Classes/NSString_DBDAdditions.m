//
//  NSString_DBDAdditions.m
//  iTheeWed
//
//  Created by Mark Lorenz on 26-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "NSString_DBDAdditions.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (NSString_DBDAdditions)

-(NSString*) stringByRemovingUnfriendlyChars{
	return [[[[[self stringByReplacingOccurrencesOfString:@"\"" withString:@"."]
			   stringByReplacingOccurrencesOfString:@"'" withString:@"."]
			  stringByReplacingOccurrencesOfString:@"\\" withString:@"."]
			 stringByReplacingOccurrencesOfString:@"&" withString:@"."]
			stringByReplacingOccurrencesOfString:@"+" withString:@"."];
}

-(NSString*) asciiSHA1digest{  //http://spitzkoff.com/craig/?p=122 not sure about the correctness of this.
	//const char *cstr = [input cStringUsingEncoding:NSASCIIStringEncoding]; //php requires ASCII for SHA1
	//NSData *data = [NSData dataWithBytes:cstr length:input.length];
	NSData *data = [self dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(data.bytes, data.length, digest);
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
	for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
	
	return output;
}

-(NSString*) decodeCharacterEntityReferences{
	return [[[[[self stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]
	 stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""]
	 stringByReplacingOccurrencesOfString:@"&apos;" withString:@"\'"]
	 stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"]
	 stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
}

-(NSString*) encodeCharacterEntityReferences{
	return [[[[[self stringByReplacingOccurrencesOfString:@"&" withString:@"&amp;"]
			   stringByReplacingOccurrencesOfString:@"\"" withString:@"&quot;"]
			  stringByReplacingOccurrencesOfString:@"\'" withString:@"&apos;"]
			 stringByReplacingOccurrencesOfString:@"<" withString:@"&lt;"]
			stringByReplacingOccurrencesOfString:@">" withString:@"&gt;"];
}

-(NSString*) replaceDumbTwitterChars{
	return [[self stringByReplacingOccurrencesOfString:@"&" withString:@"%26"]
			stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
}

+(NSString*) numberToCurrencyString:(NSNumber*)number{
	NSNumberFormatter *currencyFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	return [currencyFormatter stringFromNumber:number];
}
-(NSNumber*) currencyStringToNumber{
	NSNumberFormatter *currencyFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[currencyFormatter setNumberStyle:NSNumberFormatterNoStyle];
	return [currencyFormatter numberFromString:self];
}

-(BOOL) isValidCurrencyCharacter{
	if([self isEqualToString:@"1"] || [self isEqualToString:@"2"] ||[self isEqualToString:@"3"] || [self isEqualToString:@"4"] ||
	   [self isEqualToString:@"5"] || [self isEqualToString:@"6"] || [self isEqualToString:@"7"] || [self isEqualToString:@"8"] ||
	   [self isEqualToString:@"9"] || [self isEqualToString:@"0"] || [self isEqualToString:@"."] || self.length == 0){
		return YES;
	}
	return NO;	
}

@end