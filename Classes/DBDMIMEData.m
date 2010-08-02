
//  DBDMIMEData.m
//  iTheeWed
//
//  Created by Mark Lorenz on 2/16/10.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.


#import "DBDMIMEData.h"


@implementation DBDMIMEData
@synthesize encoding;
@synthesize boundary;

-(void)dealloc{
	[boundary release];
	[_instanceStorage release];
	
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
	[super dealloc];
}

+(id) MIMEDataWithFormDictionary:(NSDictionary*)dictionary{
	DBDMIMEData *MIMEData = [[[DBDMIMEData alloc] init] autorelease];
		MIMEData.encoding = NSUTF8StringEncoding;
		
	for (NSString *key in [dictionary allKeys]){
		if ([key isKindOfClass:[NSString class]])
			[MIMEData appendMIMEFormValue:[dictionary objectForKey:key] forField:key];
	}
	
	return MIMEData;
}

-(void) appendMIMEFormValue:(NSString*)value forField:(NSString*)field{
	if (!_instanceStorage)
		_instanceStorage = [[NSMutableDictionary alloc] init];
	[_instanceStorage setObject:value forKey:field];
}

-(void) appendMIMEDataValue:(NSData*)value withExtendedInformation:(NSArray*)info{
	if (!_instanceStorage)
		_instanceStorage = [[NSMutableDictionary alloc] init];
	[_instanceStorage setObject:value forKey:info];
}

-(NSData*) MIMEdata{
	if (!boundary)
		[self generateBoundary];
	
	return [self compileMIMEData];
}

-(NSString*)description{
	NSData *data = [self MIMEdata];
	return [NSString stringWithCString:[data bytes] length:[data length]];
}

@end

@implementation DBDMIMEData (DBDMIMEData_hidden)

-(void) generateBoundary{
	NSData *data = [self compileMIMEData];
	NSString *dataAsString = [NSString stringWithCString:[data bytes] length:[data length]];
	NSString *proposedBoundary = [[[NSDate date] description] stringByReplacingOccurrencesOfString:@" " withString:@""];
	while ([dataAsString rangeOfString:proposedBoundary].length) //look for the propsed string in the data
		proposedBoundary = [[NSDate date] description];
	
	
	self.boundary = proposedBoundary;
}

-(NSData*) compileMIMEData{
	NSMutableData *data = [NSMutableData data];
	
	NSString * boundaryString = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary]; 
	[data appendData:[boundaryString dataUsingEncoding:encoding]]; 
	
	// do text based keys first
	for (id key in _instanceStorage){
		if ([[_instanceStorage objectForKey:key] isKindOfClass:[NSString class]] && [key isKindOfClass:[NSString class]]){
			NSString *line = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key, [_instanceStorage objectForKey:key]];
			[data appendData:[line dataUsingEncoding:encoding]];
			[data appendData:[boundaryString dataUsingEncoding:encoding]];
		}
	}
	
	for (id key in _instanceStorage){
		if ([[_instanceStorage objectForKey:key] isKindOfClass:[NSData class]] && [key isKindOfClass:[NSArray class]]){
			NSString *fieldName = [(NSArray*)key objectAtIndex:0];
			NSString *fileName = [(NSArray*)key objectAtIndex:1];
			NSString *contentType = [(NSArray*)key objectAtIndex:2];
			[data appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";\r\nfilename=\"%@\"\r\nContent-Type: %@\r\n\r\n", fieldName, fileName, contentType] dataUsingEncoding:encoding]]; 
			[data appendData:[_instanceStorage objectForKey:key]];
			break; //only run this once through, boundaries are only put in once
		}
	}	
	
	NSString * boundaryStringFinal = [NSString stringWithFormat:@"\r\n--%@--\r\n", boundary];
	[data appendData:[boundaryStringFinal dataUsingEncoding:encoding]];

	return data;
}

@end
