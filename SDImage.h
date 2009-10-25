#import <UIKit/UIKit.h>


@interface SDImage : NSObject {}

+ (UIImage*) imageNamed: (NSString*) theName;

@end


@interface UIImage (Pattern)

- (void) drawHorizontalPatternInRect: (CGRect) theRect;

@end


@interface UIImage (Scaling)

- (UIImage*) imageScaledToFitSize: (CGSize) theSize;

@end