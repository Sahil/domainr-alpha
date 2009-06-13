//
//  FavouritesViewController.m
//  Domainr
//
//  Created by Sahil Desai on 5/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define AVAILABLE 0
#define MAYBE 1
#define TAKEN 2

#import "FavouritesViewController.h"
#import "ResultCell.h"
#import "ResultWrapper.h"
#import "ResultViewController.h"

@implementation FavouritesViewController


- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

- (id)init {
    if (self = [super initWithStyle:UITableViewStylePlain]) {
		
	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	prefs = [NSUserDefaults standardUserDefaults];
	favouritesArray = (NSMutableArray *)[prefs arrayForKey:@"favourites"];
	[[self navigationItem] setTitle:@"Settings"];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
																   style:UIBarButtonItemStyleDone
																  target:self
																  action:@selector(done:)];
	[[self navigationItem] setRightBarButtonItem:doneButton];
	[doneButton release];
}

- (void)viewDidUnload {
	
}

- (void)done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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

#pragma mark Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(favouritesArray == nil) return 40;
	
	NSDictionary *domainInfo = [favouritesArray objectAtIndex:indexPath.row];	
	NSString *domain = [[[domainInfo objectForKey:@"domain"] retain] autorelease];
	CGSize aSize;	
	aSize = [domain sizeWithFont:[UIFont systemFontOfSize:18.0f] 
			   constrainedToSize:CGSizeMake(230.0, 1000.0)  
				   lineBreakMode:UILineBreakModeTailTruncation];  
	return aSize.height+35;	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(favouritesArray == nil) return 0;
	return [favouritesArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    ResultCell *cell = (ResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		cell = [[[ResultCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if(favouritesArray != nil) {
		
		NSDictionary *domainInfo = [favouritesArray objectAtIndex:indexPath.row];	
		NSString *domain = [[[domainInfo objectForKey:@"domain"] retain] autorelease];
		NSString *availability = [[[domainInfo objectForKey:@"availability"] retain] autorelease];
		
		ResultWrapper *wrapper = [[ResultWrapper alloc] init];
		[wrapper setDomainName:domain];
		[wrapper setAvailability:availability];
		
		if([availability isEqualToString:@"available"]){
			[wrapper setImageType:AVAILABLE];
		}
		else if([availability isEqualToString:@"maybe"]) {
			[wrapper setImageType:MAYBE];		
		}
		else if([availability isEqualToString:@"taken"]) {
			[wrapper setImageType:TAKEN];		
		}
		else {
			[wrapper setImageType:2];
		}
		
		[cell setResultWrapper:wrapper];		
	}
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
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


- (void)dealloc {
    [super dealloc];
}


@end

