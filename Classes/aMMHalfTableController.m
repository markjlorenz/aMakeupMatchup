//
//  aMMHalfTableController.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 25-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "aMMHalfTableController.h"

@interface aMMHalfTableController (aMMHalfTableController_hidden)
-(NSArray*) tableSourceData;
@end

@implementation aMMHalfTableController
@synthesize key;	
@synthesize autocompletePartial;
@synthesize additionalPredicateKeysAndValues;
@synthesize prefillOptions;
@synthesize observer;

-(void)dealloc{
	[key release];
	[autocompletePartial release];
	[additionalPredicateKeysAndValues release];
	[prefillOptions release];
	
	ML_DEBUG(NSLog(@"Class dealloc: %@", [NSString stringWithCString:object_getClassName(self)]));
	[super dealloc];
}


@end

@implementation aMMHalfTableController (aMMHalfTableController_hidden)

#pragma mark --Table View Methods--

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self valuesWithPartialMatch:autocompletePartial].count;
}

-(NSArray*) objectsForSource{
	if (!self.key){return nil;} //save some time
	
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Makeup" inManagedObjectContext:[DBDCoreDataWrapper managedObjectContext]]; 
	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease]; 
	[request setEntity:entityDescription]; 
	NSArray *propertiesToFetchArray = [[NSArray alloc] initWithObjects:self.key,nil];
	[request setPropertiesToFetch:propertiesToFetchArray];
	//	[request setReturnsDistinctResults:NO];
	[propertiesToFetchArray release];
	
	NSPredicate *basePredicate = [NSPredicate predicateWithFormat:@"%K like '?*'", key];
	NSMutableArray *predicates = [[NSMutableArray alloc] init];
	[predicates addObject:basePredicate];
	for (NSString* additionalKey in [additionalPredicateKeysAndValues allKeys]){
		NSPredicate *predicate; // this odd if then structure is needed for when the textfield is blank.
		if ([[additionalPredicateKeysAndValues objectForKey:additionalKey] isEqualToString:@""])
			predicate = [NSPredicate predicateWithFormat:@"%K == %@", additionalKey, [additionalPredicateKeysAndValues objectForKey:additionalKey]];
		else 
			predicate = [NSPredicate predicateWithFormat:@"%K like %@", additionalKey, [additionalPredicateKeysAndValues objectForKey:additionalKey]];
		[predicates addObject:predicate];
	}
	NSPredicate *compoundPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
	[request setPredicate:compoundPredicate];
	
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:YES]; 
	[request setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]]; 
	[sortDescriptor release]; 
	NSError *error = nil; 
	
	NSArray *array = [[DBDCoreDataWrapper managedObjectContext] executeFetchRequest:request error:&error]; 
	if (array == nil){ 
		// Deal with error... 
		NSLog(@"an error occured fetching the results for the autocomplete table");
	} 		
	return array;
}

-(NSArray*) tableSourceData{
	NSArray *array = [self objectsForSource];
	
	NSMutableArray *result = [[[NSMutableArray alloc] init] autorelease];
	[result addObjectsFromArray:prefillOptions];
	for (id object in array){
		// sillyness to only show unique results.
		BOOL existingEntry = NO;
		for (NSString* existingKey in result){
			if ([existingKey isEqualToString:[(NSObject*)object valueForKeyPath:key]]){
				existingEntry = YES;
				break;
			}
		}
				
		if (!existingEntry)
			[result addObject:[(NSObject*)object valueForKeyPath:key]];
	}
	
	return result;
}

-(NSArray*) valuesWithPartialMatch:(NSString*)partial{
	if(partial.length){
		NSMutableArray *tempArray = [[[NSMutableArray alloc] init] autorelease];
		for (NSString *option in [self tableSourceData]) {
			NSRange textRange;
			textRange =[[option lowercaseString] rangeOfString:[partial lowercaseString]];
			if(textRange.location != NSNotFound){
				[tempArray addObject:option]; 
			}
		}
		return tempArray;
	}
	return [self tableSourceData];
}
			
			
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.backgroundView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TableCell.png"]] autorelease];
    }
    
	if (indexPath.row < [self valuesWithPartialMatch:autocompletePartial].count){
		cell.textLabel.text = [[self valuesWithPartialMatch:autocompletePartial] objectAtIndex:indexPath.row];
	}
	
	cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if([observer respondsToSelector:@selector(tableValueSelected:forKey:)])
		[observer tableValueSelected:[tableView cellForRowAtIndexPath:indexPath].textLabel.text forKey:self.key];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [self.key capitalizedString];
}

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