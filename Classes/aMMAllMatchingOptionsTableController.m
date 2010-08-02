//
//  aMMAllMatchingOptionsTableController.m
//  aMakeupMatchup
//
//  Created by Mark Lorenz on 26-Apr-2010.
//  Copyright 2010 Dapple Before Dawn. All rights reserved.
//

#import "aMMAllMatchingOptionsTableController.h"
#import "aMMAllMatchingOptionsCell.h"
#import "DBDGeneralMacros.h"
#import "DBDCoreDataWrapper.h"
#import "Makeup.h"


@implementation aMMAllMatchingOptionsTableController
@synthesize matchingMakeup;
@synthesize canDelete;

- (void)dealloc {
	[matchingMakeup release];
	
	[super dealloc];
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];

	UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"MainMenuBackground" ofType:@"png"]]];
	background.frame = [[UIScreen mainScreen] applicationFrame];
	[self.parentViewController.view insertSubview:background atIndex:0];
	self.view.backgroundColor = [UIColor clearColor];
	
	// Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	self.navigationController.navigationBarHidden = NO;
	self.title = DBDLocalizedString(@"All Matches");
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return matchingMakeup.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	aMMAllMatchingOptionsCell *cell = (aMMAllMatchingOptionsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
    if (cell == nil) {
        cell = [[[aMMAllMatchingOptionsCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	cell.product.text = [(Makeup*)[matchingMakeup objectAtIndex:indexPath.row] product];
	cell.brand.text = [(Makeup*)[matchingMakeup objectAtIndex:indexPath.row] brand];
	cell.formula.text = [(Makeup*)[matchingMakeup objectAtIndex:indexPath.row] formula];
	cell.color.text = [(Makeup*)[matchingMakeup objectAtIndex:indexPath.row] color];
	
	NSArray *imageOptions = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"product" ofType:@"plist"]];
	for (NSString *imageName in imageOptions){
		if ([cell.product.text isEqualToString:imageName]){
			cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:@"png"]];
			break;
		}
	}
	if (!cell.imageView.image)
		cell.imageView.image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Other" ofType:@"png"]];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 82;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
	return canDelete ? YES:NO;
}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[DBDCoreDataWrapper managedObjectContext] deleteObject:[matchingMakeup objectAtIndex:indexPath.row]];
		[DBDCoreDataWrapper forceContextSave];
		[matchingMakeup removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



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

