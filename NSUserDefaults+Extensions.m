#import "NSUserDefaults+Extensions.h"


@implementation NSUserDefaults (Extensions)

    static BOOL hasSyncedDefaults = NO;
    + (NSUserDefaults*) userDefaults; {
        if (!hasSyncedDefaults) {
            NSMutableDictionary* defaultsDictionary = [NSMutableDictionary dictionary];
			[defaultsDictionary setObject: @"1" forKey: @"AllowLandscape"];
            [[NSUserDefaults standardUserDefaults] registerDefaults: defaultsDictionary];
            hasSyncedDefaults = YES;
        }
        return [NSUserDefaults standardUserDefaults];
    }

@end