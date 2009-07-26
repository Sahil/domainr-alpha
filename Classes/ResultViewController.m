//
//  ResultViewController.m
//  Domainr
//
//  Created by Sahil Desai on 5/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ResultViewController.h"


@implementation ResultViewController

@synthesize domain;
@synthesize status;

- (id)initWithStyle:(UITableViewStyle)style {
    if (self = [super initWithStyle:style]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//	[self setTitle:domain];
}

- (void)viewWillAppear:(BOOL)animated {
	[self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidUnload {
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	[[cell textLabel] setTextAlignment:UITextAlignmentCenter];

	if(indexPath.row == 0){
		[[cell textLabel] setFont:[UIFont boldSystemFontOfSize:28]];
		[[cell textLabel] setText:domain];
	}
	else if(indexPath.row == 1) {
		[[cell textLabel] setFont:[UIFont systemFontOfSize:14.0]];
		if([status isEqualToString:@"available"]){
			[[cell textLabel] setTextColor:[UIColor greenColor]];
			[[cell textLabel] setText:@"This domain is available."];
		}
		if([status isEqualToString:@"maybe"]){
			[[cell textLabel] setTextColor:[UIColor greenColor]];
			[[cell textLabel] setText:@"This domain might be available."];
		}
		else if([status isEqualToString:@"taken"]){
			[[cell textLabel] setTextColor:[UIColor redColor]];
			[[cell textLabel] setText:@"This domain is taken."];
		}
		else if([status isEqualToString:@"unavailable"]){
			[[cell textLabel] setTextColor:[UIColor redColor]];
			[[cell textLabel] setText:@"This domain is not available."];
		}
		else if([status isEqualToString:@"top-level domain"]){
			[[cell textLabel] setTextColor:[UIColor darkGrayColor]];
			[[cell textLabel] setText:@"Top-Level Domain."];
		}
		else if([status isEqualToString:@"subdomain"]){
			[[cell textLabel] setTextColor:[UIColor darkGrayColor]];
			[[cell textLabel] setText:[NSString stringWithFormat:@"Subdomain of %@.",domain]];
		}
	}
	else if(indexPath.row == 2) {
		[[cell textLabel] setFont:[UIFont systemFontOfSize:14]];
		[[cell textLabel] setText:@"Register / More information"];
	}
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc {
    [super dealloc];
}


@end

