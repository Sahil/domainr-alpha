#import "Result.h"

@implementation Result

	@synthesize domainName, availability, path, registerURL, registrars, resultCell, imageType;

	- (void)dealloc; {
		Release(domainName);
		Release(availability);
		Release(registrars);
		Release(registerURL);
		[super dealloc];
	}

	- (NSMutableArray *)registrars; {
		if(!registrars)
			registrars = [[NSMutableArray alloc] init];
		return registrars;
	}

	-(void)setAvailability:(NSString *)avail; {
		if(avail == availability)
			return;
		
		Release(availability);
		
		if([avail isEqualToString:NSLocalizedString(@"available",nil)]){
			availability = [avail retain];
			imageType = kAvailable;
		}
		else if([avail isEqualToString:NSLocalizedString(@"maybe",nil)]) {
			availability = [avail retain];
			imageType = kMaybe;
		}
		else if([avail isEqualToString:NSLocalizedString(@"taken",nil)]) {
			availability = [avail retain];
			imageType = kTaken;
		}
		else if([avail isEqualToString:NSLocalizedString(@"tld",nil)]) {
			imageType = kTLD;
			availability = [@"top-level domain" retain];
		}
		else if([avail isEqualToString:NSLocalizedString(@"known",nil)]) {
			imageType = kTLD;
			availability = [@"subdomain" retain];
		}
		else if([avail isEqualToString:NSLocalizedString(@"unavailable",nil)]) {
			availability = [avail retain];
			imageType = kUnavailable;
		}
		else {
			availability = [avail retain];
			imageType = kTaken;
		}
	}

	-(BOOL)isResolvable; {
		if(imageType == kAvailable || imageType == kUnavailable || imageType == kTLD || imageType == kMaybe) {
			return NO;
		}
		return YES;
	}

@end
