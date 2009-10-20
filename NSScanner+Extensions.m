#import "NSScanner+Extensions.h"


@implementation NSScanner (Increment)

    - (void) incrementScanLocation; {
        if (![self isAtEnd]) {
            [self setScanLocation: [self scanLocation]+1];
        }
    }

@end