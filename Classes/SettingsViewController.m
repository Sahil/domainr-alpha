//
//  SettingsViewController.m
//  Domainr
//
//  Created by Sahil Desai on 5/25/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

- (id)initWithStyle:(UITableViewStyle)style {
	if (self = [super initWithStyle:style]) {
	}
	return self;
}

- (id)init {
    if (self = [super initWithStyle:UITableViewStyleGrouped]) {

	}
	return self;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	prefs = [NSUserDefaults standardUserDefaults];
	[[self navigationItem] setTitle:@"Settings"];
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:)];
	[[self navigationItem] setRightBarButtonItem:doneButton];
	[doneButton release];
}

- (void)viewDidUnload {
	
}

- (void)done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (void)toggleSwitch:(id)sender {
	UISwitch *aSwitch = (UISwitch *)sender;
	
	if([aSwitch isOn]){
		[prefs setBool:YES forKey:@"autocorrectSpelling"];
	}
	else {
		[prefs setBool:NO forKey:@"autocorrectSpelling"];
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:@"AutocorrectionNotification" object:nil];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
	
	if(indexPath.section == 0){
		if(indexPath.row == 0){
			UISwitch *mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(200, 8, 0, 0)];
			//[mySwitch setOn:[prefs boolForKey:@"autocorrectSpelling"] animated:YES];
			mySwitch.on = [prefs boolForKey:@"autocorrectSpelling"];
			[mySwitch addTarget:self action:@selector(toggleSwitch:) forControlEvents:UIControlEventValueChanged];
			[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
			[[cell textLabel] setText:@"Auto-correction"];
			[[cell contentView] addSubview:mySwitch];
		}
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

