#import "ResultViewController.h"
#import "Result.h"

@implementation ResultViewController

	@synthesize result;

	- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation; {
		return interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;
	}

	- (void)dealloc {
		Release(result);
		[super dealloc];
	}

	- (id)initWithResult:(Result *)newResult; {
		self = [super initWithStyle:UITableViewStyleGrouped];
		self.result = newResult;
		self.title = [newResult domainName];
		return self;
	}

	- (void)viewWillAppear:(BOOL)animated; {
		isGoingBack = YES;
		[self.navigationController setNavigationBarHidden:NO animated:YES];
		[super viewWillAppear:animated];
	}

	- (void)viewWillDisappear:(BOOL)animated; {
		if(isGoingBack) [self.navigationController setNavigationBarHidden:YES animated:YES];
		[super viewWillDisappear:animated];
	}

	- (void)viewDidLoad; {
		tldInfoOpen = toolsOpen = NO;
		
		[super viewDidLoad];
	}

	- (void)viewDidUnload; {
	}

#pragma mark UITableView methods

	enum kSections {
		kRegisterSection = 0,
		kMailSection,
		kTLDSection,
		kToolSection
	};

	- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
		return 4;
	}

	- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
		if(section == kRegisterSection) {
			return 1;
		}
		else if(section == kMailSection) {
			return 1;
		}	
		else if(section == kTLDSection) {
			return 1;
		}
		else if(section == kToolSection) {
			if(toolsOpen) {
				if([result isResolvable]) {
					return 3;
				}
				return 2;
			}
			return 1;
		}
		return 0;
	}

	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
		id cell = nil;
		
		if(indexPath.section == kRegisterSection) {
			cell = (UITableViewCell *)[tableView cellForClass:[UITableViewCell class]];
			[cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
			[[cell textLabel] setText:NSLocalizedString([result isResolvable] ? @"Is it for sale?" : @"Register",nil)];
		}
		else if(indexPath.section == kMailSection) {
			cell = (UITableViewCell *)[tableView cellForClass:[UITableViewCell class]];
			if(indexPath.row == 0) {
				[[cell textLabel] setText:NSLocalizedString(@"Save as Email",nil)];
			}
		}
		else if(indexPath.section == kTLDSection) {
			cell = (UITableViewCell *)[tableView cellForClass:[UITableViewCell class]];
			if(indexPath.row == 0) {
				[[cell textLabel] setText:NSLocalizedString(@"TLD Info",nil)];
				[cell setAccessoryType:UITableViewCellAccessoryNone];
			}
			if (tldInfoOpen) {
				if(indexPath.row == 1) {
					
				}
			}
		}
		else if(indexPath.section == kToolSection) {
			cell = (UITableViewCell *)[tableView cellForClass:[UITableViewCell class]];
			if(indexPath.row == 0) {
				[[cell textLabel] setText:NSLocalizedString(@"Tools",nil)];
				[cell setAccessoryType:UITableViewCellAccessoryNone];
				[cell setAccessoryView:[[[UIImageView alloc] initWithImage:toolsOpen ? [SDImage imageNamed:@"RevealDisclosureIndicatorUp.png"] : [SDImage imageNamed:@"RevealDisclosureIndicatorDown.png"]] autorelease]];
				[[cell textLabel] setTextColor:toolsOpen ? [UIColor grayColor] : [UIColor blackColor]];
				return cell;
			}
			else if([result isResolvable] && indexPath.row == 1) {
				[[cell textLabel] setText:NSLocalizedString(@"Visit Site (www)",nil)];
				[[cell textLabel] setTextColor:[UIColor blackColor]];
				[cell setAccessoryView:nil];
				[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			}
			else if((![result isResolvable] && indexPath.row == 1) || indexPath.row == 2) {
				[[cell textLabel] setText:NSLocalizedString(@"WHOIS",nil)];
				[[cell textLabel] setTextColor:[UIColor blackColor]];
				[cell setAccessoryView:nil];
				[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
			}
		}
		return cell;
	}

	- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
		if(indexPath.section == kRegisterSection) {
			isGoingBack = NO;
			NSString *apiRegisterURL = [NSString stringWithFormat:@"http://domai.nr/api/register?domain=%@",result.domainName];
			WebViewController *webViewController = [[[WebViewController alloc] initWithAddress:apiRegisterURL] autorelease];
			[self.navigationController pushViewController:webViewController animated:YES];
		}
		else if(indexPath.section == kMailSection) {
			if(indexPath.row == 0) {				//email
				[self displayComposerSheet];
			}
		}
		else if(indexPath.section == kTLDSection) { //tld info
			tldInfoOpen = !tldInfoOpen;
		}
		else if(indexPath.section == kToolSection) { //tools
			
			if(indexPath.row == 0) {
				toolsOpen = !toolsOpen;
				[tableView deselectRowAtIndexPath:indexPath animated:YES];
				[tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationFade];	
			}
			else if([result isResolvable] && indexPath.row == 1) {
					isGoingBack = NO;
					WebViewController *webViewController = [[[WebViewController alloc] initWithAddress:[NSString stringWithFormat:@"http://domai.nr/%@/www",result.domainName]] autorelease];
					[self.navigationController pushViewController:webViewController animated:YES];
			}
			else if((![result isResolvable] && indexPath.row == 1) || indexPath.row == 2) {
				isGoingBack = NO;
				WebViewController *webViewController = [[[WebViewController alloc] initWithAddress:[NSString stringWithFormat:@"http://domai.nr/%@/whois",result.domainName]] autorelease];
				[self.navigationController pushViewController:webViewController animated:YES];				
			}
		}
		if(!(indexPath.section == kMailSection && indexPath.row == 0)) {
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
	}

#pragma mark -

	- (void)displayComposerSheet; {
		isGoingBack = NO; 
		MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
		picker.mailComposeDelegate = self;
		[picker setToRecipients:nil];
		[picker setSubject:[NSString stringWithFormat:NSLocalizedString(@"Domainr saved domain: %@",nil),result.domainName]];
		
		NSString *emailBody = [NSString stringWithFormat:@"%@",@""];
		[picker setMessageBody:emailBody isHTML:NO];		
		[self presentModalViewController:picker animated:YES];
		[picker release];
	}

	- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error; {
		[self becomeFirstResponder];
		isGoingBack = YES; 
		[self dismissModalViewControllerAnimated:YES];
	}

@end
