#import "MainViewController.h"
#import "ResultCell.h"
#import	"Reachability.h"

@implementation MainViewController

	@synthesize myTableView;
	@synthesize mySearchBar;

	- (void)dealloc {
		Release(myTableView);
		Release(mySearchBar);
		Release(activityIndicator);
		Release(internetReach);
		[super dealloc];
	}

#pragma mark -

	- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation; {
		return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
	}

	- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation; {
		if(keyboardHidden) {
			[self setKeyboardState:NO];
		}
		else {
			[self setKeyboardState:YES];
		}
		[myTableView reloadData];
	}

#pragma mark UIView methods

	- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
		if(self = [super initWithNibName:nibNameOrNil bundle: nil]) {
			//customize
		}		
		return self;
	}

	- (void)viewDidAppear:(BOOL)animated; {
		[super viewDidAppear: animated];
	}

	- (void)viewDidLoad {
		internetReach = [[Reachability reachabilityForInternetConnection] retain];
		[internetReach startNotifer];
				
		[myTableView setSeparatorColor:UIColorFromRGB(0xEEEEEE)];

		[mySearchBar becomeFirstResponder];
		[self setKeyboardState:YES];
		[self toggleActivityIndicator:NO];
		
		[super viewDidLoad];
	}

#pragma mark -
#pragma mark Various helpers
#pragma mark -

	- (BOOL)networkAvailable {
		
		if ([internetReach currentReachabilityStatus] == NotReachable) {
			UIAlertView *networkAlert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Sorry, the network isn't available." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
			[networkAlert show];
			Release(networkAlert);
			return NO;
		}
		return YES;
	}

	- (void)toggleActivityIndicator:(BOOL)show; {
		[self _hideClearButton];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDuration: 0.3];
		[UIView setAnimationDelegate:self];
		if(show)
			[activityIndicator startAnimating];
		else
			[activityIndicator stopAnimating];
		[activityIndicator setAlpha:show ? 1 : 0];
		[UIView commitAnimations];
	}

	- (void)setKeyboardState:(BOOL)show; {
		keyboardHidden = !show;
		
		CGRect newFrame = [myTableView frame];
		if(show) {
			newFrame.size.height = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? 460 - 44 - KEYBOARD_HEIGHT_PORTRAIT : 300 - 44 - KEYBOARD_HEIGHT_LANDSCAPE;
		}
		else {
			newFrame.size.height = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? 460 - 44 : 300 - 44;
			[mySearchBar resignFirstResponder];
		}
		[myTableView setFrame:newFrame];
	}

	- (void)_showKeyboardWorkAround; {
		[self setKeyboardState:YES];
	}
	
#pragma mark -
#pragma mark UISearchBar methods
#pragma mark -

	- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar { // return NO to not become first responder
		return YES;
	}

	- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar; {
		[self performSelector:@selector(_showKeyboardWorkAround) withObject:nil afterDelay:0.5];
	}

	- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{   // called when text changes (including clear)
		
		if([searchText isEqualToString:@""]) {
			[self toggleActivityIndicator:NO];
			[results removeAllObjects];
			[myTableView reloadData];
			return;
		}
		[self search];
	}

	- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text { // called before text changes
		if(![self networkAvailable]) return NO;
		
		if(([text isEqualToString:@""] && [[mySearchBar text] length] == 0)) {
			return NO;
		}

		if(loading && ![[mySearchBar text] length] == 0) {
			[theConnection cancel];
			Release(theConnection);
			Release(receivedData);		
		}
		return YES;
	}

	- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {                     // called when keyboard search button pressed
		[self setKeyboardState:NO];
		if(![self networkAvailable]) return;
		
		[self search];
	}

	- (void)search {
		NSString *searchText = [mySearchBar text];
		
		[self toggleActivityIndicator:YES];
		loading = YES;
		
		NSString *urlSearchString = [NSString stringWithFormat: @"http://domai.nr/api/json/search?q=%@", searchText];
		
		NSMutableURLRequest *theRequest = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: [urlSearchString escapedString]]
																  cachePolicy: NSURLRequestUseProtocolCachePolicy
															  timeoutInterval: 60.0];
		[theRequest setHTTPMethod:@"GET"];
		
		theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
		if (theConnection) {
			NSLog(@"Request submitted");
			receivedData=[[NSMutableData data] retain];
		} else {
			NSLog(@"Failed to submit request"); 
		}
	}

#pragma mark -
#pragma mark NSURLConnection methods 
#pragma mark -

	- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
		[receivedData appendData:data];
	}

	- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(_showClearButton) object:nil];
		NSError *error = nil;
		jsonString = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];
		jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
		NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
		
		if(results)
			Release(results);
		results = [[NSMutableArray alloc] init];
		
		for (NSDictionary *result in [dictionary objectForKey:@"results"]) {
			Result *newResult = [[Result alloc] init];
			newResult.domainName = [result objectForKey:@"domain"];
			newResult.availability = [result objectForKey:@"availability"];
			newResult.path = [result objectForKey:@"path"];
			
			NSMutableArray *registrars = [result objectForKey:@"registrars"];
			for (NSString *registrar in registrars) {
				[newResult.registrars addObject:registrar];				
			}
			[results addObject:newResult];
		}
		
		[receivedData setLength:0];
		Release(receivedData);
		Release(connection);

		[myTableView reloadData];
		loading = NO;
		[self toggleActivityIndicator:NO];
		[self performSelector:@selector(_showClearButton) withObject:nil afterDelay:0];
	}

	- (void)_showClearButton; {
		[whiteBgView setHidden:YES];
	}

	- (void)_hideClearButton; {
		[whiteBgView setHidden:NO];
	}

#pragma mark -
#pragma mark Table view methods
#pragma mark -

	- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
		if(results == nil) return 40;
		
		NSString *domainNameString = [[results objectAtIndexA:indexPath.row] domainName];
		CGSize aSize;	
		aSize = [domainNameString sizeWithFont:[UIFont systemFontOfSize:17] 
							 constrainedToSize:CGSizeMake(UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? 260.0 : 420, 1000)  
						lineBreakMode:UILineBreakModeTailTruncation];  
		return aSize.height+35;	
	}

	- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
		return 1;
	}

	- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		if(results == nil) return 0;
		return [results count];
	}

	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		ResultCell *cell = (ResultCell *)[tableView cellForClass:[ResultCell class]];
		[cell setResult:[results objectAtIndexA:indexPath.row]];
		[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
		return cell;
	}

	- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}

@end
