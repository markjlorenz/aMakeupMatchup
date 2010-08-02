//
//  MLRateMeReminder.m
//  itryiton
//
//  Created by Mark Lorenz on 10/12/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "MLRateMeReminder.h"

@interface MLRateMeReminder (hidden)

#pragma mark --Private Methods--
-(NSString*) getAppStoreURL:(NSURL*)fetchURL;
- (NSString *)dataFilePath;
-(void) saveData;
-(BOOL)	dataFileExists;
-(void) initFromFile;
-(BOOL) firstRunSetup;
@end

@implementation MLRateMeReminder
@synthesize appStorePointer;

+ (MLRateMeReminder*)executeRemiderWithURLPointer:(NSString*)appStoreURLPointerURL{
	MLRateMeReminder *thisReminder = [[[MLRateMeReminder alloc] initAndExecute:appStoreURLPointerURL] autorelease];
	return thisReminder;
}


-(id) initAndExecute:(NSString*)appStoreURLPointerURL{
	//check app open count.  If it's a multiple of 10 and the user hasn't rated the app yet, ask them to.	
//	[self resetToFactory];// uncomment if you need to restore to factory default
	
	if (self = [super init]){
		self.appStorePointer = appStoreURLPointerURL;
		
		if(![self firstRunSetup]){// only run the rest of the code if it's not the first time
			[self initFromFile];
			
			if(mayPrompt && !(numberTimesOpened % promptAfter_Times)){ //if we mayPrompt, and the app's been opened a divisable by 10 number of times, the prompt them to rate
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Please Rate This App"
																message:@"You've used this app a few times.  Please give it a rating in the app store." 
															   delegate:self
													  cancelButtonTitle:@"Sure, I'll Do It Now"
													  otherButtonTitles:@"I'll Do It Later", @"Don't Ask Me Again", nil];
				alert.tag = MLRateMeReminder10xAlert;
				[alert show];
				[alert release];
				[self retain];  //or else we won't be here to answer the delegate callback
			}
		}
	}
	return self;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
	if(alertView.tag == MLRateMeReminder10xAlert){
		switch (buttonIndex) {
			case 0:;
				NSURL *pointerURL = [[[NSURL alloc] initWithString:appStorePointer] autorelease];
				NSString *appStoreURLString = [self getAppStoreURL:pointerURL];
				mayPrompt = 0;
				[self saveData];
				
				NSURL *appStoreURL = [NSURL URLWithString:appStoreURLString];
				[[UIApplication sharedApplication] openURL:appStoreURL];
				break;
			case 1:;
				// for this case we need do nothing
				break;
			case 2:;
				mayPrompt = 0;
				[self saveData];
				break;
			default:;
				break;
		}
	}
	[self release]; //let ourselves go from the delegate callback.
}

-(NSString*) getAppStoreURL:(NSURL*)fetchURL{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	
	NSMutableURLRequest *URLrequest = [ [ NSMutableURLRequest alloc ] initWithURL: fetchURL]; 	
	NSError *error = nil;
	NSData *returnData = [ NSURLConnection sendSynchronousRequest: URLrequest returningResponse: nil error: &error];
	if(!returnData){
		printf("Submission Error : %s\n", [[error localizedDescription] UTF8String]);
		
		NSString *errorMessage = [[NSString alloc] initWithUTF8String:[[error localizedDescription] UTF8String]];
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" 
														message:errorMessage
													   delegate:self 
											  cancelButtonTitle: @"OK"
											  otherButtonTitles:nil];
		[alert show];
		[alert release];
		[errorMessage release];
		}
	
	NSString *returnString = [[[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding] autorelease];
	
	[URLrequest release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;	
	
	return returnString;
}

-(void) dealloc{
	[appStorePointer release];
	[super dealloc];
}

#pragma mark --Persistence Methods--
- (NSString *)dataFilePath { 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"MLRateMeRemiderData.txt"]; 
} 

-(void) saveData{ 
	NSArray *saveDataArray = [NSArray arrayWithObjects:[NSNumber numberWithInt:numberTimesOpened], [NSNumber numberWithInt: mayPrompt], nil];
	[saveDataArray writeToFile:[self dataFilePath] atomically:YES];
}

-(BOOL)	dataFileExists{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	return 	[fileManager fileExistsAtPath:[self dataFilePath]];
}

-(void) initFromFile{
	NSArray *data = [NSArray arrayWithContentsOfFile:[self dataFilePath]];
	numberTimesOpened = [[data objectAtIndex:0] intValue ] + 1; //unpack and increment
	mayPrompt = [[data objectAtIndex:1] intValue];
	[self saveData];
}

-(BOOL) firstRunSetup{
	if(![self dataFileExists]){ //setup the datafile
		numberTimesOpened = 1; // app opened 1 time
		mayPrompt = 1; //may ask
		[self saveData];
		return YES;
	}
	return NO;
}

-(void) resetToFactory{
	NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager removeItemAtPath:[self dataFilePath] error:nil];
}
@end
