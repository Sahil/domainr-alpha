#import <UIKit/UIKit.h>


@interface NSString (Data)

+ (id) stringWithData: (NSData*) data;
+ (NSString*) stringWithCString: (const char *) cString;
- (id) data;

@end


@interface NSString (Extensions)

- (BOOL) hasSubstring: (id) theString;

- (NSString*) escapedString;
- (NSString*) unescapedString;
- (NSString*) stringByRemovingHTMLEntities;

- (NSRange) rangeBetween: (NSString*) a and: (NSString*) b;
- (NSString*) substringBetween: (NSString*) a and: (NSString*) b;

- (NSString*) stringByRemovingPrefix: (NSString*) thePrefix;
- (NSString*) stringByRemovingSuffix: (NSString*) theSuffix;
- (NSString*) trimmedString;

- (NSString*) stringByReplacingString: (id) a withString: (id) b;

@end


@interface NSMutableString (Replace)

- (void) appendStringA: (id) theString;
- (unsigned int) replaceOccurrencesOfString: (NSString*) target withString: (NSString*) replacement;

@end


@interface NSString (UIKitDrawing)

- (CGSize) drawInRect: (CGRect) theRect highlightedString: (NSString*) highlightedString normalFont: (UIFont*) normalFont highlightedFont: (UIFont*) highlightedFont;

@end