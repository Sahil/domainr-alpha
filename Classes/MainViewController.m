//
//  MainViewController.m
//  Domainr
//
//  Created by Sahil Desai on 5/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define AVAILABLE 0
#define MAYBE 1
#define TAKEN 2
#define DURATION 0.2f

#import "MainViewController.h"

#import "ResultCell.h"
#import "ResultWrapper.h"
#import "SettingsViewController.h"
#import	"Reachability.h"

@implementation MainViewController

@synthesize myTableView;
@synthesize toolbar;
@synthesize mySearchBar;
@synthesize settingsController;

- (void)dealloc {
	[myTableView release];
	[toolbar release];
	[mySearchBar release];
    [super dealloc];
}

- (void)loadView {
	[super loadView];
	
	barForBorder = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
	backgroundBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, -1, 320, 44)];
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[activityIndicator setFrame:CGRectMake(0.0, 0.0, 25.0, 25.0)];
	activityIndicator.autoresizingMask =
    (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | 
	 UIViewAutoresizingFlexibleTopMargin  | UIViewAutoresizingFlexibleBottomMargin);
	loadingView = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];

	UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
	NSArray *newButtons = [NSArray arrayWithObjects: flexSpace, loadingView, nil];
	[backgroundBar setItems:newButtons];
	
	mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
	[mySearchBar setDelegate:self];
	[mySearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	
	myTableView = [[UITableView alloc] initWithFrame: CGRectMake(0.0f, 44.0f, 320.0f, 200.0f) style: UITableViewStylePlain];
	[myTableView setDelegate:self];
	[myTableView setDataSource:self];
	[myTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
	
	toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f, 416.0f, 320.0f, 44.0f)];
	UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"prefs.png"] 
																	   style:UIBarButtonItemStylePlain 
																	  target:self
																	  action:@selector(showSettings:)];
	NSArray *newItems = [NSArray arrayWithObjects:settingsButton, nil];
	[toolbar setItems:newItems];
	
	[self.view addSubview:barForBorder];
	[self.view addSubview:backgroundBar];
	[self.view addSubview:mySearchBar];
	[self.view addSubview:myTableView];
	[self.view addSubview:toolbar];
}

- (void)viewDidLoad {
	[super viewDidLoad];	
	prefs = [NSUserDefaults standardUserDefaults];
	[mySearchBar becomeFirstResponder];
}

- (void)viewDidUnload {

}

- (void)showSettings:(id)sender {
	if(settingsController == nil)
	{	
		settingsController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
		navController = [[UINavigationController alloc] initWithRootViewController:settingsController];		
	}
	[self.navigationController presentModalViewController:navController animated:YES];
}

- (BOOL)networkAvailable {
	if ([[Reachability sharedReachability] internetConnectionStatus] == NotReachable) {
        UIAlertView *networkAlert = [[UIAlertView alloc] initWithTitle:@"Network Error" message:@"Sorry, the network isn't available." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [networkAlert show];
		return NO;
    }
	return YES;
}

#pragma mark UISearchBarDelegate methods

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar { // return NO to not become first responder
	[ myTableView setFrame:CGRectMake(0.0f, 44.0f, 320.0f, 200.0f) ];
	return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{   // called when text changes (including clear)
	if([searchText hasSuffix:@" "]) {
		[mySearchBar setText:[searchText substringToIndex:([searchText length]-2)]];
		return;
	}
	
	if([searchText isEqualToString:@""])
	{
		[ UIView beginAnimations: nil context: nil ];
		[ UIView setAnimationCurve: UIViewAnimationCurveEaseInOut ];
		[ UIView setAnimationDuration: DURATION];
		[ mySearchBar setFrame:CGRectMake(0, 0, 320, 44)];
		[ mySearchBar layoutSubviews];
		[ UIView commitAnimations];	
		[activityIndicator stopAnimating];
		return;
	}
	[self search:searchBar];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text { // called before text changes
	if(![self networkAvailable]) return NO;
	
	if(([text isEqualToString:@""] && [[mySearchBar text] length] == 0) || [text isEqualToString:@" "])
	{
		if(![text isEqualToString:@" "]) {
			[activityIndicator stopAnimating];
			return YES;
		}
		return NO;
	}

	if(loading && ![[mySearchBar text] length] == 0) {
		[theConnection cancel];
		[theConnection release];
		[receivedData release];		
	}
	return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {                     // called when keyboard search button pressed
	[ myTableView setFrame:CGRectMake(0.0f, 44.0f, 320.0f, 372.0f) ];
	[searchBar resignFirstResponder];
	if(![self networkAvailable]) return;
	
	[self search:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{                   // called when cancel button pressed
	[searchBar resignFirstResponder];
}

- (void)search:(id)sender {
	
	[ UIView beginAnimations: nil context: nil ];
	[ UIView setAnimationCurve: UIViewAnimationCurveEaseInOut ];
	[ UIView setAnimationDuration: DURATION ];
	[ mySearchBar setFrame:CGRectMake(0, 0, 280, 44)];
	[ mySearchBar layoutSubviews];
	[ UIView commitAnimations];	
	
	[activityIndicator startAnimating];
	loading = YES;
	
	NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:
																		 [NSString stringWithFormat: @"http://domai.nr/api/json/search?q=%@", [mySearchBar text]]]
															cachePolicy:NSURLRequestUseProtocolCachePolicy
														timeoutInterval:60.0];
	[theRequest setHTTPMethod:@"GET"];
	
	theConnection=[[NSURLConnection alloc] initWithRequest:theRequest delegate:self];
	
	if (theConnection) {
		NSLog(@"Request submitted");
		receivedData=[[NSMutableData data] retain];
	} else {
		NSLog(@"Failed to submit request"); 
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	jsonString = [[NSString alloc] initWithData:receivedData encoding:NSASCIIStringEncoding];	
	
	//NSLog(@"JSON: %@",jsonString);
	
	NSError *error = nil;
	
	jsonData = [jsonString dataUsingEncoding:NSUTF32BigEndianStringEncoding];
	
	NSDictionary *dictionary = [[CJSONDeserializer deserializer] deserializeAsDictionary:jsonData error:&error];
	
	resultsArray = [[NSMutableArray alloc] init];
	NSArray *list = [[dictionary objectForKey:@"results"] retain];
	
	for (NSDictionary *result in list) {
		[resultsArray addObject:result];
	}	
	
	[receivedData setLength:0];
	[receivedData release];
	[connection release];

	[myTableView reloadData];
	loading = NO;
	[activityIndicator stopAnimating];
	[ UIView beginAnimations: nil context: nil ];
	[ UIView setAnimationCurve: UIViewAnimationCurveEaseInOut ];
	[ UIView setAnimationDuration: DURATION ];
	[ mySearchBar setFrame:CGRectMake(0, 0, 320, 44)];
	[ mySearchBar layoutSubviews];
	[ UIView commitAnimations];	
}

#pragma mark Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if(resultsArray == nil) return 40;
	
	NSDictionary *domainInfo = [resultsArray objectAtIndex:indexPath.row];	
	NSString *domain = [[[domainInfo objectForKey:@"domain"] retain] autorelease];
	CGSize aSize;	
	aSize = [domain sizeWithFont:[UIFont systemFontOfSize:18.0f] 
				constrainedToSize:CGSizeMake(230.0, 1000.0)  
					lineBreakMode:UILineBreakModeTailTruncation];  
	return aSize.height+35;	
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(resultsArray == nil) return 0;
	return [resultsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    static NSString *CellIdentifier = @"Cell";
    ResultCell *cell = (ResultCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
		cell = [[[ResultCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier] autorelease];
    }
	if(resultsArray != nil)
	{	
		NSDictionary *domainInfo = [resultsArray objectAtIndex:indexPath.row];	
		NSString *domain = [[[domainInfo objectForKey:@"domain"] retain] autorelease];
		NSString *availability = [[[domainInfo objectForKey:@"availability"] retain] autorelease];
		
		ResultWrapper *wrapper = [[ResultWrapper alloc] init];
		[wrapper setDomainName:domain];
		[wrapper setAvailability:availability];
		
		if([availability isEqualToString:@"available"]){
			[wrapper setImageType:AVAILABLE];
		}
		else if([availability isEqualToString:@"maybe"]) {
			[wrapper setImageType:MAYBE];		
		}
		else if([availability isEqualToString:@"taken"]) {
			[wrapper setImageType:TAKEN];		
		}
		else {
			[wrapper setImageType:2];
		}

		[cell setResultWrapper:wrapper];
	}
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
