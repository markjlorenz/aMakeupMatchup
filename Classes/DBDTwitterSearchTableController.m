//
//  DBDTwitterSearchTableController.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 7-May-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "DBDTwitterSearchTableController.h"
#import "JSON.h"
#import "DBDTwitterFetchDelegate.h"
#import "DBDTwitterSearchTableCell.h"
#import "DBDUIViewTools.h"
#import "NSDate_DBDAdditions.h"
#import "NSString_DBDAdditions.h"

@implementation DBDTwitterSearchTableController
@synthesize table;
@synthesize _hashTag;

-(void)dealloc{
	[tweets release];
	[_hashTag release];
	[twitterIcons release];
	[activeFetchDelegate cancel];
	[activeFetchDelegate release];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
	[super dealloc];
}

-(id) initWithTable:(UITableView*)tableview{
	if (self = [super init]){
		self.table = tableview;
		twitterData = [[NSMutableData data] retain];
		tweets = nil;
		twitterIcons = nil;
		
		networkActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		networkActivity.center = [table.superview convertPoint:table.center toView:table];
		networkActivity.alpha = 0.0;
		[table addSubview:networkActivity];
		[networkActivity release];
		
	}
	return self;
}

#pragma mark --Twitter Methods--

-(void) fetchFeed{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	[networkActivity startAnimating];
	[networkActivity fadeInWithDelegate:nil];
	
	activeFetchDelegate = [[DBDTwitterFetchDelegate alloc] initWithController:self hashTag:_hashTag];
	[activeFetchDelegate fetchFeed];
}

-(void)twitterFetchDelegate:(DBDTwitterFetchDelegate*)delegate fetchedArray:(NSArray*)array{
	[networkActivity stopAnimating];
	[networkActivity fadeOutWithDelegate:nil];
	
	[tweets release];
	tweets = [array retain];
	[self.table reloadData];
	[delegate release];
	
	//setup another to fetch the icons
	activeFetchDelegate = [[DBDTwitterFetchDelegate alloc] initWithController:self hashTag:_hashTag];
	[activeFetchDelegate fetchTwitterIcons:tweets existingImages:[[twitterIcons mutableCopy] autorelease]];
}
-(void)twitterFetchDelegate:(DBDTwitterFetchDelegate*)delegate fetchedImages:(NSDictionary*)usernamesAndImages{
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	[twitterIcons release];
	twitterIcons = [usernamesAndImages retain];
	[self.table reloadData];
	[delegate release];
	activeFetchDelegate = nil;
}
-(void)twitterFetchDelegateFailedOnImages:(NSArray*)arg{
// don't really need to do anything in this method
//	DBDTwitterFetchDelegate *delegate = [arg objectAtIndex:0]
//	NSError *error = [arg objectAtIndex:1];
}

#pragma mark --Table View Methods--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tweets.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    DBDTwitterSearchTableCell *cell = (DBDTwitterSearchTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
//        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		cell = [[[DBDTwitterSearchTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];	
    }
    
	NSDictionary *tweetDictionary = [tweets objectAtIndex:indexPath.row];
	cell.usernamelabel.text = [tweetDictionary objectForKey:kDBDTwitterFetchDelegate_TwitterAPIFromUserKey];
	cell.textview.text = [[tweetDictionary objectForKey:kDBDTwitterFetchDelegate_TwitterAPITweetTextKey] decodeCharacterEntityReferences];
	cell.iconView.image = [twitterIcons objectForKey:[tweetDictionary objectForKey:kDBDTwitterFetchDelegate_TwitterAPIFromUserKey]];
	  
	NSString *twitterDate = [tweetDictionary objectForKey:kDBDTwitterFetchDelegate_TwitterAPITweetDate];
	cell.datelabel.text = [NSDate dateDifferenceStringFromString:twitterDate withFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZZ"];;
	
	[cell.textview setFrameHeight:cell.textview.contentSize.height];
	
	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	//make a dummy cell
	DBDTwitterSearchTableCell *cell = cell = [[[DBDTwitterSearchTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""] autorelease];//[self tableView:tableView cellForRowAtIndexPath:indexPath]
	NSDictionary *tweetDictionary = [tweets objectAtIndex:indexPath.row];
	cell.usernamelabel.text = [tweetDictionary objectForKey:kDBDTwitterFetchDelegate_TwitterAPIFromUserKey];
	cell.textview.text = [tweetDictionary objectForKey:kDBDTwitterFetchDelegate_TwitterAPITweetTextKey];
	
	return  cell.usernamelabel.bounds.size.height + cell.textview.contentSize.height > cell.iconView.bounds.size.height ? cell.usernamelabel.bounds.size.height + cell.textview.contentSize.height: cell.iconView.bounds.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	if([observer respondsToSelector:@selector(tableValueSelected:forKey:)])
//		[observer tableValueSelected:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forKey:self.key];
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//	return [self.key capitalizedString];
//}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */


/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


@end

@implementation DBDTwitterSearchTableController (DBDTwitterSearchTableController_hidden)


@end