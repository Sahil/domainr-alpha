#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "Reachability.h"

@class Result;

@interface ResultViewController : UITableViewController <MFMailComposeViewControllerDelegate> {
	Result *result;
	Reachability *internetReach;
	NetworkStatus status;
	
	BOOL tldInfoOpen;
	BOOL toolsOpen;
	BOOL isGoingBack;
}

@property (retain) Result *result;

- (id)initWithResult:(Result*)newResult;
- (void)displayComposerSheet;

@end