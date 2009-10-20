#import "UITableView+Extensions.h"


@implementation UITableView (Extensions)
    
    static NSMutableDictionary* classNames = nil;
    + (NSString*) stringFromClass: (Class) theClass; {
        if (!classNames) classNames = [[NSMutableDictionary alloc] init];
        NSString* result = [classNames objectForKey: theClass];
        if (!result) {
            result = NSStringFromClass(theClass);
            [classNames setObject: result forKey: theClass];
        }
        return result;
    }

    - (UITableViewCell*) cellForClass: (Class) cellClass; {
        UITableViewCell* result = [self dequeueReusableCellWithIdentifier: [UITableView stringFromClass: cellClass]];
        if (!result)
            result = [[[cellClass alloc] initWithStyle:UITableViewStylePlain reuseIdentifier: [UITableView stringFromClass: cellClass]] autorelease];
        return result;
    }

@end