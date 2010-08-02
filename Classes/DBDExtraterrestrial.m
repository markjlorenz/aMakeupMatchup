//
//  DBDExtraterrestrial.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 1-May-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
///   http://www.dapplebeforedawn.com/amakeupmatchup/database_connect_logins.php

#import "DBDExtraterrestrial.h"
#import "NSString_DBDAdditions.h"

@interface DBDExtraterrestrial (DBDExtraterrestrial_hidden)
+(void) postAsynchronousPHPRequest:(NSString*)request toPage:(NSString*)URL delegate:(id)delegate;
@end	
	
@implementation DBDExtraterrestrial

-(void)dealloc{
	
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
	[super dealloc];
}

+(void) phoneHomeWithKeys:(NSArray*)keys values:(NSArray*)values toPage:(NSString*)URL{
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]; //not part of the hash!
	NSString *UDID = [UIDevice currentDevice].uniqueIdentifier;
	NSMutableString *nameCompilation = [[[NSMutableString alloc] init] autorelease];
	
	[nameCompilation appendString:@"_DeRbY_"];
	[nameCompilation appendString:UDID];
	for (NSString *value in values)
		[nameCompilation appendString:value];
	NSString *name = [[nameCompilation stringByRemovingUnfriendlyChars] asciiSHA1digest];
	
	NSMutableString *requestCompilation = [[[NSMutableString alloc] init] autorelease];
	[requestCompilation appendFormat:@"UDID=%@&", UDID];
	for (int i = 0; i < keys.count; i++){
		[requestCompilation appendFormat:@"%@=%@&", [keys objectAtIndex:i], [[values objectAtIndex:i] stringByRemovingUnfriendlyChars]];
	}
	[requestCompilation appendFormat:@"name=%@&", name];
	[requestCompilation appendFormat:@"version=%@", version];

	[DBDExtraterrestrial postAsynchronousPHPRequest:requestCompilation toPage:URL delegate:nil];
}

@end

@implementation DBDExtraterrestrial (DBDExtraterrestrial_hidden)
+(void) postAsynchronousPHPRequest:(NSString*)request toPage:(NSString*)URL delegate:(id)delegate{
	// a php post request might look like: @"&email=%@&IO_loc_lat=%@&IO_loc_lon=%@&IO_time=%@&OH_master=%i"
	//NSData *requestData = [ NSData dataWithBytes: [ request UTF8String ] length: [ request length ] ];
	NSData *requestData = [ request dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]; //PHP will need ASCII encoding when we calculate the SHA hash with it.
	NSMutableURLRequest *URLrequest = [ [ NSMutableURLRequest alloc ] initWithURL: [ NSURL URLWithString: URL ] ]; 
	[ URLrequest setHTTPMethod: @"POST" ];
	[ URLrequest setHTTPBody: requestData ];
	
	[ NSURLConnection connectionWithRequest:URLrequest delegate:delegate];
	[URLrequest release];
}
@end

