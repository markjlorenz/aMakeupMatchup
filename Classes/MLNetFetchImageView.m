//
//  MLNetFetchImageView.m
//  
//
//  Created by Mark Lorenz on 9/16/09.
//  Copyright 2009 Black Box Technology. All rights reserved.
//

#import "MLNetFetchImageView.h"


@implementation MLNetFetchImageView


- (id)initWithFetchURL:(NSString*)URL identifier:(NSString*)ident bootStrapImage:(UIImage*)bootStrap{
	identifier = [ident copy];
	NSArray *savedData = [[NSArray alloc] initWithContentsOfFile:[self dataFilePath]];
	if(savedData.count){
		UIImage *savedImage = [[UIImage alloc] initWithData:[savedData objectAtIndex:1]];
		self = [super initWithImage:savedImage];
		[savedImage release];
	}
	else{
		self = [super initWithImage:bootStrap];
	}
	
	//attempt to fetch new image for next time  php will check if the file should be fetched based on date.
	NSURL *fetchURL = [[NSURL alloc] initWithString:URL];
	responseData = [[NSMutableData alloc] init];
	[self asnychronousImageFetch:fetchURL];
	
	[fetchURL release];
	[savedData release];
	
	return self;
}
						
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}  

-(void) asnychronousImageFetch:(NSURL*)fetchURL{
	[fetchURL retain];
	NSString *appName = [[[NSBundle mainBundle] infoDictionary]   objectForKey:@"CFBundleName"];
	NSDate *fileModification = [self getFileModificationDate];
	NSString *request =  [NSString stringWithFormat:@"&ident=%@&appname=%@&filemodification=%f", identifier, appName, [fileModification timeIntervalSince1970]];
	
//	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
//	[[NSURLCache sharedURLCache] setDiskCapacity:0];
	
	NSData *requestData = [ NSData dataWithBytes: [ request UTF8String ] length: [ request length ] ];
	NSMutableURLRequest *URLrequest = [ [ NSMutableURLRequest alloc ] initWithURL: fetchURL ]; 
	[ URLrequest setHTTPMethod: @"POST" ];
	[ URLrequest setHTTPBody: requestData ];
	
	[ NSURLConnection connectionWithRequest:URLrequest delegate:self];	 //no need to track the connection, there is only 1
	
	[fetchURL release];
	[ URLrequest release];

}
			
/*  drawRect: in a UIImageView subclass is different than drawRect: in a regular UIView subclass 
- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
    // Drawing code
}*/


- (void)dealloc {
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
	[responseData release];
	[identifier release];
    [super dealloc];
}

#pragma mark -- Local File Handling --
- (NSString *)dataFilePath{ 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *fileName = [[[NSString alloc] initWithFormat:@"MLNetFetchImageView_ImageProperties_%@.txt", identifier] autorelease];
    return  [documentsDirectory stringByAppendingPathComponent:fileName]; 
} 

-(NSDate*) getFileModificationDate{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSError *error;
	NSDictionary *attributes = [fileManager attributesOfItemAtPath:[self dataFilePath] error:nil];
	return [attributes objectForKey:NSFileModificationDate];
}
#pragma mark --NSURLConnection Delegate Methods--
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
	[responseData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
	//	NSLog(@"I recieved some response");
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	NSLog(error.localizedDescription);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
	//if there was a response, save the new image for use next time;
	if (responseData.length > MIN_IMAGE_SIZE){ 
//		NSLog(@"response length, %i", responseData.length);
		NSArray *saveArray = [NSArray arrayWithObjects:identifier, responseData, nil];
		[saveArray writeToFile:[self dataFilePath] atomically:YES];
	}
}
@end
