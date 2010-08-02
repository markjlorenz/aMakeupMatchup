//
//  DBDTwitterFetchDelegate.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 7-May-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "DBDTwitterFetchDelegate.h"
#import "JSON.h"
#import "DBDGeneralMacros.h"

@implementation DBDTwitterFetchDelegate
@synthesize _controller;
@synthesize	_hash;
@synthesize responseLimit;

-(void)dealloc{
	[self cancel];
	
	[_hash release];
	[_data release];
	[_connection release];
	
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
	[super dealloc];
}

-(id) initWithController:(id)controller hashTag:(NSString*)hash{
	if (self = [super init]){
		self.controller = controller;
		_data = [[NSMutableData alloc] init];
		self.hash = hash;
		responseLimit = 30;
		backgroundIsCancelled = NO;
	}
	return self;
}

-(void) cancel{
	[_connection cancel];
	backgroundIsCancelled = YES;
}

-(void) fetchFeed{	
	backgroundIsCancelled = NO;
	
	NSURLRequest *twitterURL = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%i", kDBDTwitterFetchDelegate_FetchURL_1, _hash, kDBDTwitterFetchDelegate_FetchURL_2, responseLimit]]];
	_connection = [[NSURLConnection alloc] initWithRequest:twitterURL delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[_data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog( [NSString stringWithFormat:@"Connection failed: %@", [error description]] );
	
	//construct a dummy JSON string
	NSString *errorMessage = [NSString stringWithFormat:@"%@%@", DBDLocalizedString(@"Error connecting to Twitter: "), [error localizedDescription]];
	NSString *phoneyTwitterResponse = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",
									   @"{\"", 
									   kDBDTwitterFetchDelegate_TwitterAPITweetsKey, 
									   @"\":[{\"", 
									   kDBDTwitterFetchDelegate_TwitterAPITweetTextKey,
									   @"\":\"",
									   errorMessage,
									   @"\",\"",
									   kDBDTwitterFetchDelegate_TwitterAPIUserImageURL,
									   @"\":\"",
									   @"not-a-url",
									   @"\",\"",
									   kDBDTwitterFetchDelegate_TwitterAPIFromUserKey,
									   @"\":\"",
									   DBDLocalizedString(@"Error"),
									   @"\",\"",
									   kDBDTwitterFetchDelegate_TwitterAPITweetDate,
									   @"\":\"",
									   [[NSDate date] description],
									   @"\"",
									   @"}]}"];
	
	NSArray *tweets = [[phoneyTwitterResponse JSONValue] valueForKey:kDBDTwitterFetchDelegate_TwitterAPITweetsKey];
	NSMutableArray *phoneyTwitterJSONs = [[[NSMutableArray alloc] init] autorelease];
	for (int i = 0; i < responseLimit; i++)
		[phoneyTwitterJSONs addObject:[tweets objectAtIndex:0]];
	
	if (!backgroundIsCancelled)
		if ([_controller respondsToSelector:@selector(twitterFetchDelegate:fetchedArray:)])
			[_controller twitterFetchDelegate:self fetchedArray:phoneyTwitterJSONs];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {	
	NSString *responseString = [[[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding] autorelease];
	
	NSArray *tweets = [[responseString JSONValue] valueForKey:kDBDTwitterFetchDelegate_TwitterAPITweetsKey];
	
	if (!backgroundIsCancelled)
		if ([_controller respondsToSelector:@selector(twitterFetchDelegate:fetchedArray:)])
			[_controller twitterFetchDelegate:self fetchedArray:tweets];
}

-(void)fetchTwitterIcons:(NSArray*)JSONTweets existingImages:(NSDictionary*)existingImages{
	backgroundIsCancelled = NO;
	
	//find unique usernames
	[_existingImages release];
	_existingImages = [existingImages retain];
	NSMutableDictionary *usernamesAndImageURLs = [[[NSMutableDictionary alloc] init] autorelease];
	for (NSDictionary *tweetDict in JSONTweets){
		
		//check if name already exists
		BOOL duplicateName = NO;
		for (NSString *username in [usernamesAndImageURLs allKeys]){
			if ([username isEqualToString:[tweetDict objectForKey:kDBDTwitterFetchDelegate_TwitterAPIFromUserKey]]){
				duplicateName = YES;
				break;
			}
		}
		
		//if not already in the dict, add it
		if (!duplicateName)
			[usernamesAndImageURLs setObject:[tweetDict objectForKey:kDBDTwitterFetchDelegate_TwitterAPIUserImageURL] forKey:[tweetDict objectForKey:kDBDTwitterFetchDelegate_TwitterAPIFromUserKey]];
	}
	
	//remove the existing images
	[usernamesAndImageURLs removeObjectsForKeys:[existingImages allKeys]];
	
	//fetch them in another runloop, it will notify the controller
	[self performSelectorInBackground:@selector(asynchronousFetchIcons:) withObject:usernamesAndImageURLs];
}

-(void)asynchronousFetchIcons:(NSDictionary*)usernamesAndImageURLs{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	NSMutableDictionary *usernamesAndImages = [[[NSMutableDictionary alloc] init] autorelease];
	
	for (NSString *username in [usernamesAndImageURLs allKeys]){
		if (backgroundIsCancelled)
			return;
		
		NSString *imageURL = [usernamesAndImageURLs objectForKey:username];
		NSURLRequest *URLRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]];
		
		NSURLResponse *response = nil;
		NSError *error = nil;
		NSData *imageData = [NSURLConnection sendSynchronousRequest:URLRequest returningResponse:&response error:&error];
		
		if (error){
			NSLog([error localizedDescription]);
			if (!backgroundIsCancelled){
				if ([_controller respondsToSelector:@selector(twitterFetchDelegateFailedOnImages:)]){
					NSArray *array = [NSArray arrayWithObjects:self, error, nil];
					[_controller performSelectorOnMainThread:@selector(twitterFetchDelegateFailedOnImages:) withObject:array waitUntilDone:YES];
				}
			}
		}
		
		UIImage *image = [UIImage imageWithData:imageData];
		if (image) //fail silently if the image fails to load
			[usernamesAndImages setObject:image forKey:username];
	}
	
	if (!backgroundIsCancelled){	
		[self performSelectorOnMainThread:@selector(imagesFetched:) withObject:usernamesAndImages waitUntilDone:YES]; //Ok the block the B/G Thread
	}
	
	[pool release];
}

-(void) imagesFetched:(NSDictionary*)usernamesAndImages{
	NSMutableDictionary *newAndExistingImages = [NSMutableDictionary dictionaryWithDictionary:_existingImages];
	[newAndExistingImages addEntriesFromDictionary:usernamesAndImages];
	
	if (!backgroundIsCancelled)
		if ([_controller respondsToSelector:@selector(twitterFetchDelegate:fetchedImages:)])
			[_controller twitterFetchDelegate:self fetchedImages:[[newAndExistingImages copy] autorelease]];
}

@end

@implementation DBDTwitterFetchDelegate (DBDTwitterFetchDelegate_hidden)
@end