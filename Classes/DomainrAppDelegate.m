#import "DomainrAppDelegate.h"
#import "MainViewController.h"

@implementation DomainrAppDelegate

@synthesize window;
@synthesize navigationController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
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
