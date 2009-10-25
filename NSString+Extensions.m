#import "NSScanner+Extensions.h"
#import "NSString+Extensions.h"


/* Data */

@implementation NSString (Data)

    + (id) stringWithData: (NSData*) data; {
        id result = [[[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding] autorelease];
        if (!result) result = [[[NSString alloc] initWithData: data encoding: NSASCIIStringEncoding] autorelease];
        return result;
    }
    
    + (NSString*) stringWithCString: (const char *) cString; {
        if (!cString)
            return nil;
        return [NSString stringWithCString: cString encoding: NSUTF8StringEncoding];
    }

    - (id) data; {
        return [self dataUsingEncoding: NSASCIIStringEncoding allowLossyConversion: YES];
    }

@end


/* Extensions */

@implementation NSString (Extensions)

    - (BOOL) hasSubstring: (id) theString; {
        if (theString)
            return ([self rangeOfString: theString options: 0].location != NSNotFound);
        return NO;
    }
    
    - (NSString*) escapedString; {
        return [[[self stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] stringByReplacingString: @"&" withString: @"%26"] stringByReplacingString: @"+" withString: @"%2B"];
    }

    - (NSString*) unescapedString; {
        return [self stringByReplacingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    }

    - (NSString*) stringForHTMLEntity: (id) theEntity; {
        id table = [NSArray arrayWithObjects:
            @"nbsp", // "&#160;"
            @"iexcl", // "&#161;"
            @"cent", // "&#162;"
            @"pound", // "&#163;"
            @"curren", // "&#164;"
            @"yen", // "&#165;"
            @"brvbar", // "&#166;"
            @"sect", // "&#167;"
            @"uml", // "&#168;"
            @"copy", // "&#169;"
            @"ordf", // "&#170;"
            @"laquo", // "&#171;"
            @"not", // "&#172;"
            @"shy", // "&#173;"
            @"reg", // "&#174;"
            @"macr", // "&#175;"
            @"deg", // "&#176;"
            @"plusmn", // "&#177;"
            @"sup2", // "&#178;"
            @"sup3", // "&#179;"
            @"acute", // "&#180;"
            @"micro", // "&#181;"
            @"para", // "&#182;"
            @"middot", // "&#183;"
            @"cedil", // "&#184;"
            @"sup1", // "&#185;"
            @"ordm", // "&#186;"
            @"raquo", // "&#187;"
            @"frac14", // "&#188;"
            @"frac12", // "&#189;"
            @"frac34", // "&#190;"
            @"iquest", // "&#191;"
            @"Agrave", // "&#192;"
            @"Aacute", // "&#193;"
            @"Acirc", // "&#194;"
            @"Atilde", // "&#195;"
            @"Auml", // "&#196;"
            @"Aring", // "&#197;"
            @"AElig", // "&#198;"
            @"Ccedil", // "&#199;"
            @"Egrave", // "&#200;"
            @"Eacute", // "&#201;"
            @"Ecirc", // "&#202;"
            @"Euml", // "&#203;"
            @"Igrave", // "&#204;"
            @"Iacute", // "&#205;"
            @"Icirc", // "&#206;"
            @"Iuml", // "&#207;"
            @"ETH", // "&#208;"
            @"Ntilde", // "&#209;"
            @"Ograve", // "&#210;"
            @"Oacute", // "&#211;"
            @"Ocirc", // "&#212;"
            @"Otilde", // "&#213;"
            @"Ouml", // "&#214;"
            @"times", // "&#215;"
            @"Oslash", // "&#216;"
            @"Ugrave", // "&#217;"
            @"Uacute", // "&#218;"
            @"Ucirc", // "&#219;"
            @"Uuml", // "&#220;"
            @"Yacute", // "&#221;"
            @"THORN", // "&#222;"
            @"szlig", // "&#223;"
            @"agrave", // "&#224;"
            @"aacute", // "&#225;"
            @"acirc", // "&#226;"
            @"atilde", // "&#227;"
            @"auml", // "&#228;"
            @"aring", // "&#229;"
            @"aelig", // "&#230;"
            @"ccedil", // "&#231;"
            @"egrave", // "&#232;"
            @"eacute", // "&#233;"
            @"ecirc", // "&#234;"
            @"euml", // "&#235;"
            @"igrave", // "&#236;"
            @"iacute", // "&#237;"
            @"icirc", // "&#238;"
            @"iuml", // "&#239;"
            @"eth", // "&#240;"
            @"ntilde", // "&#241;"
            @"ograve", // "&#242;"
            @"oacute", // "&#243;"
            @"ocirc", // "&#244;"
            @"otilde", // "&#245;"
            @"ouml", // "&#246;"
            @"divide", // "&#247;"
            @"oslash", // "&#248;"
            @"ugrave", // "&#249;"
            @"uacute", // "&#250;"
            @"ucirc", // "&#251;"
            @"uuml", // "&#252;"
            @"yacute", // "&#253;"
            @"thorn", // "&#254;"
            @"yuml", // "&#255;"
        nil];
        
        unichar character = 0;
        int index = [table indexOfObject: theEntity];
        if (index != NSNotFound) {
            character = index + 160;
        } else if ([theEntity hasPrefix: @"#"]) {
            character = [[theEntity substringFromIndex: 1] intValue];
        } else if ([theEntity isEqualToString: @"quot"]) {
            return @"\"";
        } else if ([theEntity isEqualToString: @"amp"]) {
            return @"&";
        } else if ([theEntity isEqualToString: @"gt"]) {
            return @">";
        } else if ([theEntity isEqualToString: @"lt"]) {
            return @"<";
        } else {
            return @"";
        }
        
        return [NSString stringWithFormat: @"%C", character];
    }

    - (NSString*) stringByRemovingHTMLEntities; {
        id scanner = [NSScanner scannerWithString: self];
        [scanner setCaseSensitive: NO];
        [scanner setCharactersToBeSkipped: nil];
        id result = [NSMutableString string];

        NSString* string;
        while(![scanner isAtEnd]) {
            string = nil;
            [scanner scanUpToString: @"&" intoString: &string];
            if (string)
                [result appendStringA: string];
            [scanner incrementScanLocation];

            if (![scanner isAtEnd] && [self characterAtIndex: [scanner scanLocation]] != ' ') {
                string = nil;
                [scanner scanUpToString: @";" intoString: &string];
                if (string) {
                    if (![scanner isAtEnd]) {
                        string = [self stringForHTMLEntity: string];
                        [result appendStringA: string];
                        [scanner incrementScanLocation];
                    } else {
                        [result appendStringA: @"&"];
                        [result appendStringA: string];
                    }
                }
            } else if (![scanner isAtEnd] || [self characterAtIndex: [self length]-1] == '&') {
                [result appendStringA: @"&"];
            }
        }
        return result;
    }
    
    - (NSRange) rangeBetween: (NSString*) a and: (NSString*) b; 
    {
        if ([self isEqualToString: @""]) return NSMakeRange(NSNotFound,0);
        
        NSRange ra = NSMakeRange(0,0);
        NSRange rb = NSMakeRange([self length]-1,0);

        if (a) {
            if ([self length] > [a length])
                ra = [self rangeOfString: a];
            else
                ra.location = NSNotFound;
        }

        if (b && ra.location != NSNotFound) {
            NSRange searchRange = NSMakeRange(ra.location + ra.length, [self length] - ra.location - ra.length);
            if (searchRange.length > 0)
                rb = [self rangeOfString: b options: 0 range: searchRange];
        }
        
        if (ra.location == NSNotFound)
            return NSMakeRange(NSNotFound,0);
        else if (rb.location == NSNotFound)
            return NSMakeRange(ra.location + ra.length, [self length] - ra.location - ra.length);
        else
            return NSMakeRange(ra.location + ra.length, rb.location - ra.location - ra.length);
    }

    - (NSString*) substringBetween: (NSString*) a and: (NSString*) b; {
        NSRange range = [self rangeBetween: a and: b];
        if (range.location != NSNotFound)
            return [self substringWithRange: range];
        else
            return nil;
    }

    - (NSString*) stringByRemovingPrefix: (NSString*) thePrefix; {
        if ([self hasPrefix: thePrefix]) {
            return [self substringFromIndex: [thePrefix length]];
        } else {
            return self;
        }
    }

    - (NSString*) stringByRemovingSuffix: (NSString*) theSuffix; {
        if ([self hasSuffix: theSuffix]) {
            return [self substringToIndex: [self length]-[theSuffix length]];
        } else {
            return self;
        }
    }

    - (NSString*) trimmedString; {
        return [self stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    - (NSString*) stringByReplacingString: (id) a withString: (id) b; {
        id result = [NSMutableString stringWithString: self];
        [result replaceOccurrencesOfString: a withString: b options: 0 range: NSMakeRange(0, [result length])];
        return result;
    }

@end


/* Replace */

@implementation NSMutableString (Replace)

    - (void) appendStringA: (id) theString; {
        if (!EmptyString(theString))
            [self appendString: theString];
    }

    - (unsigned int) replaceOccurrencesOfString: (NSString*) target withString: (NSString*) replacement; {
        if (target && replacement)
            return [self replaceOccurrencesOfString: target withString: replacement options: 0 range: (NSRange){0, [self length]}];
        return 0;
    }

@end


/* UIKit Drawing */

@implementation NSString (UIKitDrawing)

    - (CGSize) drawInRect: (CGRect) theRect highlightedString: (NSString*) highlightedString normalFont: (UIFont*) normalFont highlightedFont: (UIFont*) highlightedFont; {
        NSRange highlightRange = (EmptyString(highlightedString)) ? NSMakeRange(NSNotFound, 0) : [self rangeOfString: highlightedString options: NSCaseInsensitiveSearch];

		CGSize size = CGSizeMake(0,0);
		CGSize out;
		
        if (highlightRange.location == NSNotFound) {
            out = [self drawAtPoint: theRect.origin forWidth: theRect.size.width withFont: normalFont lineBreakMode: UILineBreakModeTailTruncation];
            return out;
        }
		
        /* start */
        if (highlightRange.location > 0) {
            NSString* substring = [self substringToIndex: highlightRange.location];

            size = [substring drawAtPoint: theRect.origin forWidth: theRect.size.width withFont: normalFont lineBreakMode: UILineBreakModeTailTruncation];
            
            theRect.origin.x += size.width;
            theRect.size.width -= size.width;
        }
        
		out = size;
		
        if (theRect.size.width < 10)
            return out;
        
        /* middle */
        
        if (highlightRange.location >= 0 && theRect.size.width > 0) {
            NSString* substring = [self substringWithRange: highlightRange];

            size = [substring sizeWithFont: highlightedFont forWidth: theRect.size.width lineBreakMode: UILineBreakModeTailTruncation];

            if (size.width != 0) {
                [substring drawAtPoint: theRect.origin forWidth: theRect.size.width withFont: highlightedFont lineBreakMode: UILineBreakModeTailTruncation];
                theRect.origin.x += size.width;
                theRect.size.width -= size.width;
            }
        }

		out.width += size.width;		
		
			
        if (theRect.size.width < 10)
            return out;
            
        /* end */
        
        if (highlightRange.location + highlightRange.length < [self length] && theRect.size.width > 0) {
            NSString* substring = [self substringFromIndex: highlightRange.location + highlightRange.length];
            CGSize size = [substring drawAtPoint: theRect.origin forWidth: theRect.size.width withFont: normalFont lineBreakMode: UILineBreakModeTailTruncation];

			out.width += size.width;
		}
		return out;
    }

@end