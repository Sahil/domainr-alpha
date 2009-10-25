#import "DomainrAppDelegate.h"
#import "MainViewController.h"

@implementation DomainrAppDelegate

	@synthesize window;
	@synthesize navigationController;

	- (void)applicationDidFinishLaunching:(UIApplication *)application; {	
		MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
		UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
		self.navigationController = navController;
		Release(navController);
		Release(mainViewController);
		
		[self.navigationController setNavigationBarHidden:YES];
		[window addSubview:[self.navigationController view]];
		[window makeKeyAndVisible];
	}


	- (void)dealloc; {
		[window release];
		[super dealloc];
	}

@end
