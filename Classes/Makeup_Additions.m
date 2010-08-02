//
//  Makeup_Additions.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 30-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "Makeup_Additions.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString_DBDAdditions.h"

@implementation Makeup (Makeup_Additions)

#pragma mark --External Data Collection--
-(void) phoneHome{
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]; //not part of the hash!
	NSString *UDID = [UIDevice currentDevice].uniqueIdentifier;
	NSString *name = [self digest:[[NSString stringWithFormat:@"%@%@%@%@%@%@%@", @"_DeRbY_", UDID, self.makeupId, self.product, self.brand, self.formula, self.color]
								   stringByRemovingUnfriendlyChars]];
	NSString *myRequestString =  [NSString stringWithFormat:@"UDID=%@&makeup_id=%@&product=%@&brand=%@&formula=%@&color=%@&name=%@&version=%@", 
								  [UDID stringByRemovingUnfriendlyChars], [self.makeupId stringByRemovingUnfriendlyChars], [self.product stringByRemovingUnfriendlyChars], [self.brand stringByRemovingUnfriendlyChars], [self.formula stringByRemovingUnfriendlyChars], [self.color stringByRemovingUnfriendlyChars], name, version]; 
	
	[self postAsynchronousPHPRequest:myRequestString toPage:@"http://www.dapplebeforedawn.com/amakeupmatchup/database_connect.php" delegate:nil];
}

-(void) postAsynchronousPHPRequest:(NSString*)request toPage:(NSString*)URL delegate:(id)delegate{
	// a php post request might look like: @"&email=%@&IO_loc_lat=%@&IO_loc_lon=%@&IO_time=%@&OH_master=%i"
	//NSData *requestData = [ NSData dataWithBytes: [ request UTF8String ] length: [ request length ] ];
	NSData *requestData = [ request dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]; //PHP will need ASCII encoding when we calculate the SHA hash with it.
	NSMutableURLRequest *URLrequest = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: URL ] ]; 
	[ URLrequest setHTTPMethod: @"POST" ];
	[ URLrequest setHTTPBody: requestData ];
	
	[ NSURLConnection connectionWithRequest:URLrequest delegate:delegate];
	[URLrequest release];
}

-(NSString*) digest:(NSString*)input{  //http://spitzkoff.com/craig/?p=122 not sure about the correctness of this.
	//const char *cstr = [input cStringUsingEncoding:NSASCIIStringEncoding]; //php requires ASCII for SHA1
	//NSData *data = [NSData dataWithBytes:cstr length:input.length];
	NSData *data = [input dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
	uint8_t digest[CC_SHA1_DIGEST_LENGTH];
	CC_SHA1(data.bytes, data.length, digest);
	NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
	
	for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
		[output appendFormat:@"%02x", digest[i]];
	
	return output;
}


@end