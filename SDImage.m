#import "SDImage.h"


@implementation SDImage

    static NSMutableDictionary* cache = nil;

    + (UIImage*) imageNamed: (NSString*) theName; {
        if (!cache) cache = [[NSMutableDictionary alloc] init];
        UIImage* result;
        if (!(result = [cache objectForKey: theName])) {
            result = [UIImage imageNamed: theName];
            if (result)
                [cache setObject: result forKey: theName];
        }
        return result;
    }

@end


@implementation UIImage (Pattern)

    - (void) drawHorizontalPatternInRect: (CGRect) theRect; {
        int origin = theRect.origin.x;
        CGSize size = self.size;
        while (origin < theRect.origin.x + theRect.size.width) {
            [self drawInRect: CGRectMake(origin, theRect.origin.y, size.width, size.height)];
            origin += size.width;
        }
    }

@end


@implementation UIImage (Scaling)

    - (UIImage*) imageScaledToFitSize: (CGSize) theSize; {
        CGImageRef imgRef = self.CGImage;
        CGFloat width = self.size.width;
        CGFloat height = self.size.height;

        CGRect bounds = CGRectMake(0, 0, width, height);
        
        if (width > theSize.width || height > theSize.height) {
            if (width > height) {
                bounds.size.width = width / (bounds.size.height / theSize.height);
                bounds.size.height = theSize.height;
            } else if (height > width) {
                bounds.size.height = height / (bounds.size.width / theSize.width);
                bounds.size.width = theSize.width;
            } else {
                bounds.size.width = theSize.width;
                bounds.size.height = theSize.height;
            }
        }

        UIGraphicsBeginImageContext(theSize);
            [[UIColor whiteColor] set];
            UIRectFill(CGRectMake(0, 0, theSize.width, theSize.height));
        
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextScaleCTM(context, 1, -1);
            CGContextTranslateCTM(context, 0, -bounds.size.height);
            if (bounds.size.width > theSize.width)
                CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(-(bounds.size.width - theSize.width)/2, 0, bounds.size.width, bounds.size.height), imgRef);
            else if (bounds.size.height > theSize.height)
                CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, (bounds.size.height - theSize.height) / 2, bounds.size.width, bounds.size.height), imgRef);
            else
                CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, bounds.size.width, bounds.size.height), imgRef);
            UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();

        return imageCopy;
    }

@end