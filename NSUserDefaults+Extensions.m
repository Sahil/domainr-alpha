#import "NSUserDefaults+Extensions.h"


@implementation NSUserDefaults (Extensions)

    static BOOL hasSyncedDefaults = NO;
    + (NSUserDefaults*) userDefaults; {
        if (!hasSyncedDefaults) {
            NSMutableDictionary* defaultsDictionary = [NSMutableDictionary dictionary];
			
            [[NSUserDefaults standardUserDefaults] registerDefaults: defaultsDictionary];
            hasSyncedDefaults = YES;
        }
        return [NSUserDefaults standardUserDefaults];
    }

@end