#import <UIKit/UIKit.h>
#import "NSUserDefaults+Extensions.h"

#define Autorelease(A) { [A autorelease]; A = nil; }
#define Release(A) { [A release]; A = nil; }
#define instanceof(A,B) [A isKindOfClass: [B class]]

#define EmptyString(A) (!A || [A isEqualToString: @""])
#define SDLocalizedString(A, B) NSLocalizedStringFromTableInBundle(A, nil, [NSBundle bundleForClass: [self class]], B)

#define yes [NSNumber numberWithBool: YES]
#define no  [NSNumber numberWithBool: NO]

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kAvailable	 0
#define kMaybe		 1
#define kTaken	 	 2
#define kTLD		 3
#define kUnavailable 4

#define KEYBOARD_HEIGHT_PORTRAIT 216
#define KEYBOARD_HEIGHT_LANDSCAPE 162


static __inline__ int SDRandomIntBetween(int a, int b) {
    int range = b - a < 0 ? b - a - 1 : b - a + 1; 
    int value = (int)(range * ((float)random() / (float) LONG_MAX));
    return value == range ? a : a + value;
}

static __inline__ float SDRandomFloatBetween(float a, float b) {
    return a + (b - a) * ((float)random() / (float) LONG_MAX);
}

#ifdef DEBUG
    #define SDLog(...) NSLog(__VA_ARGS__)
#else
    #define SDLog(...)
#endif


@interface NSObject (Events)

- (void) postNotificationAboutSelf: (id) name;
- (void) postNotificationAboutSelfLater: (id) name;

- (void) listenForNotification: (id) name selector: (SEL) sel;
- (void) listenForNotification: (id) name selector: (SEL) sel object: (id) obj;

- (void) stopListening;

- (id) repeatingTimerWithTimeInterval: (NSTimeInterval) interval selector: (SEL) sel;

- (void) kill;

@end


@interface NSArray (Protection)

- (id) objectAtIndexA: (int) theIndex;

@end