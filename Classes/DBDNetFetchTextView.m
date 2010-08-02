//
//  DBDNetFetchTextView.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 11-May-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "DBDNetFetchTextView.h"
#import "DBDGeneralMacros.h"
#import "DBDUIViewTools.h"

@interface DBDNetFetchTextView (DBDNetFetchTextView_hidden)
-(void) setup;
@end

@implementation DBDNetFetchTextView
@synthesize _URL;

- (void)dealloc {
	[_data release];
	[_connection release];
	[_URL release];
	
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame URL:(NSString*)fetchLocation{
    if (self = [super initWithFrame:frame]) {
		self._URL = fetchLocation;
		[self setup];
    }
    return self;
}

-(void) awakeFromNib{
	[self setup];
}

-(void) cancel{
	[_connection cancel];
	isCancelled = YES;
}

-(void) fetchFeed{	
	isCancelled = NO;
	
	[networkActivity startAnimating];
	[networkActivity fadeInWithDelegate:nil];
	
	if (_URL){
		NSURLRequest *twitterURL = [NSURLRequest requestWithURL:[NSURL URLWithString:_URL]];
		_connection = [[NSURLConnection alloc] initWithRequest:twitterURL delegate:self];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	[_data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[_data appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog( [NSString stringWithFormat:@"Connection failed: %@", [error description]] );
	self.text = [NSString stringWithFormat:@"%@ \n%@", DBDLocalizedString(@"Could not connect to text source: \n"), [error localizedDescription]];

	[networkActivity stopAnimating];
	[networkActivity fadeOutWithDelegate:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {	
	NSString *responseString = [[[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding] autorelease];
	
//	if (!isCancelled) 
	self.text = responseString;
	[networkActivity stopAnimating];
	[networkActivity fadeOutWithDelegate:nil];
}

@end

@implementation DBDNetFetchTextView (DBDNetFetchTextView_hidden)
-(void) setup{
	_data = [[NSMutableData alloc] init];
	_connection = nil;
	isCancelled = NO;
	
	networkActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	networkActivity.center = self.center;//[self convertPoint:self.center toView:self];
	networkActivity.alpha = 0.0;
	[self.superview insertSubview:networkActivity aboveSubview:self];
	[networkActivity release];			
}
@end