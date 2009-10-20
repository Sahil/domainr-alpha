#import <Foundation/Foundation.h>

@class ResultCell;

@interface Result : NSObject {
	NSString *domainName;
	NSString *availability;
	NSMutableArray *registrars;
	int imageType;
	
	ResultCell *resultCell;
}

@property (retain) NSString	*domainName;
@property (retain) NSString	*availability;
@property (retain) NSMutableArray *registrars;
@property int imageType;

@property (assign) ResultCell *resultCell;

@end
