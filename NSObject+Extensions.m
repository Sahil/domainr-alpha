#import "NSObject+Extensions.h"

@implementation NSObject (Events)

/* Post Notification */

    - (void) postNotificationAboutSelf: (id) name; {
        [[NSNotificationCenter defaultCenter] postNotificationName: name object: self];
    }
    
    - (void) postNotificationAboutSelfLater: (id) name; {
        [self performSelector: @selector(postNotificationAboutSelf:) withObject: name afterDelay: 0];
    }
    

/* Listen For Notifications */
    
    - (void) listenForNotification: (id) name selector: (SEL) sel; {
        [[NSNotificationCenter defaultCenter] addObserver: self selector: sel name: name object: nil];
    }

    - (void) listenForNotification: (id) name selector: (SEL) sel object: (id) obj; {
        [[NSNotificationCenter defaultCenter] addObserver: self selector: sel name: name object: obj];
    }


/* Stop Listening For Notifications */

    - (void) stopListening; {
        [[NSNotificationCenter defaultCenter] removeObserver: self];
        [NSObject cancelPreviousPerformRequestsWithTarget: self];
    }


/* Timers */

    - (id) repeatingTimerWithTimeInterval: (NSTimeInterval) interval selector: (SEL) sel; {
        return [NSTimer scheduledTimerWithTimeInterval: interval target: self selector: sel userInfo: nil repeats: YES];
    }
    

/* Guards */

    - (void) kill; {
    }

    - (id) copyWithZone: (id) theZone; {
        return [self retain];
    }

@end


@implementation NSArray (Protection)
    
    - (id) objectAtIndexA: (int) theIndex; {
        return (theIndex > -1 && theIndex < [self count]) ? [self objectAtIndex: theIndex] : nil;
    }

@end