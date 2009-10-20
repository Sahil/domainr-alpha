#import "Result.h"

@implementation Result

	@synthesize domainName, availability, registrars, resultCell, imageType;

	- (void)dealloc; {
		Release(domainName);
		Release(availability);
		Release(registrars);
		Release(resultCell);
		[super dealloc];
	}

	- (NSMutableArray *)registrars; {
		if(!registrars)
			registrars = [[NSMutableArray alloc] init];
		return nil;
	}

	-(void)setAvailability:(NSString *)avail; {
		if(avail == availability)
			return;
		
		Release(availability);
		
		if([avail isEqualToString:@"available"]){
			availability = [avail retain];
			imageType = kAvailable;
		}
		else if([avail isEqualToString:@"maybe"]) {
			availability = [avail retain];
			imageType = kMaybe;
		}
		else if([avail isEqualToString:@"taken"]) {
			availability = [avail retain];
			imageType = kTaken;
		}
		else if([avail isEqualToString:@"tld"]) {
			imageType = kTLD;
			availability = [[NSString alloc] initWithString: @"top-level domain"];
		}
		else if([avail isEqualToString:@"known"]) {
			imageType = kTLD;
			availability = [[NSString alloc] initWithString: @"subdomain"];
		}
	}

@end
