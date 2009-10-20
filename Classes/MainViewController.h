#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"

@class Reachability;

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UINavigationBarDelegate> {	
	UINavigationController	*navController;
	IBOutlet UITableView	*myTableView;
	IBOutlet UISearchBar	*mySearchBar;
	IBOutlet UIActivityIndicatorView *activityIndicator;
	
	NSData					*jsonData;
	NSURL					*jsonURL;
	NSMutableData			*receivedData;
	NSString				*jsonString;
	NSURLConnection			*theConnection;
	
	NSString				*searchQuery;
	NSMutableArray			*results;
	NSMutableArray			*favouritesArray;
	NSMutableArray			*resultObjectsArray;
	BOOL					loading;
	
	NSDate					*previousTimeStamp;
	
	Reachability			*internetReach;
	
	BOOL					keyboardHidden;
}

@property (nonatomic, retain) UITableView	*myTableView;
@property (nonatomic, retain) UISearchBar	*mySearchBar;

- (void) toggleActivityIndicator:(BOOL)show;
- (void) setKeyboardState:(BOOL)show;

- (void) search;
- (BOOL) networkAvailable;

@end
