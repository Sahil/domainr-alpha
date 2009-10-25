#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate> {
	IBOutlet UIToolbar			*toolbar;
	IBOutlet UIWebView			*webView;
	IBOutlet UIBarButtonItem	*backButton;
    IBOutlet UIBarButtonItem	*forwardButton;
	IBOutlet UIActivityIndicatorView *spinner;
	IBOutlet UIBarButtonItem	*reloadButton;
	IBOutlet UIBarButtonItem	*fixedSpace;
	
	// title fields
    IBOutlet UIView				*titleAndAddressView;
    IBOutlet UILabel			*titleField;
    IBOutlet UILabel			*addressField;
	
	NSString					*loadAddress;
	NSMutableArray				*toolBarItems;
}

- (id) initWithAddress: (NSString*) theAddress;

@property (readonly) UIWebView *webView;

- (void)reloadAction:(id)sender;
- (void) goBack: (id) sender;
- (void) action: (id) sender;


@end
