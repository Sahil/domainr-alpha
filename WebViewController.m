#import "WebViewController.h"


@implementation WebViewController
	
	@synthesize webView;

	- (void)dealloc; {
		Release(loadAddress);
		Release(webView);
		Release(toolbar);
		Release(backButton);
		Release(forwardButton);
		
		[super dealloc];
	}

	- (id) initWithAddress: (NSString*) theAddress; {
		self = [self initWithNibName: @"WebViewController" bundle: nil];
		loadAddress = [theAddress retain];		
		return self;
	}

	- (void)viewWillAppear:(BOOL)animated; {
		[self.navigationController setNavigationBarHidden:NO animated:YES];
        [webView loadRequest: [NSURLRequest requestWithURL: [NSURL URLWithString: loadAddress]]];
        addressField.text = loadAddress;
		[super viewWillAppear:animated];
	}

	- (void)viewDidLoad; {
		self.navigationItem.titleView = titleAndAddressView;
		forwardButton.enabled = NO;
		[super viewDidLoad];
	}

	- (void)viewDidUnload; {
	}

	- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation; {
		return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
	}

	#pragma mark -

	- (void) updateButtons; {
		backButton.enabled = YES;
		forwardButton.enabled = webView.canGoForward;
	}
	
	- (void)reloadAction:(id)sender; {
		[webView reload];
	}

	- (BOOL) webView: (UIWebView*) theWebView shouldStartLoadWithRequest: (NSURLRequest*) request navigationType: (UIWebViewNavigationType) navigationType; {
		return YES;
	}

	- (void) webViewDidStartLoad: (UIWebView*) theWebView; {
		[self updateButtons];		
		
		toolBarItems = [toolbar.items mutableCopy];
		[toolBarItems removeObjectAtIndex:4];
		[toolBarItems insertObject:fixedSpace atIndex:4];
		[toolbar setItems:toolBarItems];
		Release(toolBarItems);
		spinner.hidden = NO;
		[spinner startAnimating];
	}

	- (void) webViewDidFinishLoad: (UIWebView*) theWebView; {
		[self updateButtons];
		toolBarItems = [toolbar.items mutableCopy];
		[toolBarItems removeObjectAtIndex:4];
		[toolBarItems insertObject:reloadButton atIndex:4];
		[toolbar setItems:toolBarItems];
		Release(toolBarItems);
		spinner.hidden = YES;

		titleField.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
		if (EmptyString(titleField.text))
			titleField.text = NSLocalizedString(@"Untitled", nil);
		
		if (titleField.alpha == 0) {
			[UIView beginAnimations: @"" context: nil];
			[UIView setAnimationDuration: 0.4];
			CGRect frame;
			
			titleField.alpha = 1;
			frame = [titleField frame];
			frame.origin.y = 3;
			titleField.frame = frame;
			
			frame = [addressField frame];
			frame.origin.y = 20;
			addressField.frame = frame;
			
			addressField.text = [webView.request.URL absoluteString];
			[UIView commitAnimations];
		}
	}

	- (void) webView: (UIWebView*) webView didFailLoadWithError: (NSError*) error; {
		[self updateButtons];
	}

#pragma mark -

	- (void) goBack: (id) sender; {
		if (webView.canGoBack)
			[webView goBack];
		else
			[self.navigationController popViewControllerAnimated: YES];
	}

	- (void) action: (id) sender; {
		UIActionSheet* sheet = [[[UIActionSheet alloc] initWithTitle: nil delegate: self cancelButtonTitle: NSLocalizedString(@"Cancel", nil) destructiveButtonTitle: nil otherButtonTitles: NSLocalizedString(@"Open in Safari", nil), nil] autorelease];
		[sheet showInView: [webView window]];
	}

	- (void) actionSheet: (UIActionSheet*) actionSheet clickedButtonAtIndex: (NSInteger) buttonIndex; {
		if (buttonIndex == 0)
			[[UIApplication sharedApplication] openURL: webView.request.URL];
	}


@end
