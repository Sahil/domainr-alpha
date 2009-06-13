//
//  DomainrAppDelegate.m
//  Domainr
//
//  Created by Sahil Desai on 5/24/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#define kHostName @"domai.nr"

#import "DomainrAppDelegate.h"
#import "Beacon.h"
#import "MainViewController.h"

@implementation DomainrAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize internetConnectionStatus;

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
	[[Reachability sharedReachability] setHostName:kHostName];
    [[Reachability sharedReachability] setNetworkStatusNotificationsEnabled:YES];
	self.internetConnectionStatus    = [[Reachability sharedReachability] internetConnectionStatus];
    if (self.internetConnectionStatus == NotReachable) {
        //show an alert to let the user know that they can't connect.
        UIAlertView *networkAlert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Sorry, the network isn't available." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [networkAlert show];
    }	
	
	NSString *applicationCode = @"008161fc62f835b1d2e809f9e5671971";
    [Beacon initAndStartBeaconWithApplicationCode:applicationCode
								  useCoreLocation:NO useOnlyWiFi:NO];
	
	
	MainViewController *mainViewController = [[MainViewController alloc] init];
	UINavigationController *aNavigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
	self.navigationController = aNavigationController;	
	[aNavigationController release];
	[mainViewController release];
	[self.navigationController setNavigationBarHidden:YES];
	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
