//
//  ResultView.m
//  Disqus
//
//  Created by Sahil Desai on 5/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define theRed(rgbValue) ((float)((rgbValue & 0xFF0000) >> 16))/255.0
#define theGreen(rgbValue) ((float)((rgbValue & 0xFF00) >> 8))/255.0
#define theBlue(rgbValue) ((float)(rgbValue & 0xFF))/255.0 

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "ResultView.h"
#import "ResultWrapper.h"

@implementation ResultView

@synthesize resultWrapper;
@synthesize highlighted;
@synthesize editing;

static UIFont *textFont = nil;
static UIFont *aTextFont = nil;

static UIColor *whiteColor, *blackColor, *grayColor, *darkGrayColor;

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
		textFont = [[UIFont boldSystemFontOfSize:18.0f] retain];
		aTextFont = [[UIFont systemFontOfSize:14.0f] retain];
		
		whiteColor = [[UIColor whiteColor] retain];
		blackColor = [[UIColor blackColor] retain];
		grayColor = [[UIColor darkGrayColor] retain];
		darkGrayColor = [[UIColor darkGrayColor] retain];
		
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setResultWrapper:(ResultWrapper *)newResultWrapper {
	if (resultWrapper != newResultWrapper) {
		[resultWrapper release];
		resultWrapper = [newResultWrapper retain];
	}
	[self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)lit {
	if (highlighted != lit) {
		highlighted = lit;	
		[self setNeedsDisplay];
	}
}


- (void)drawRect:(CGRect)rect {
	
	UIColor *textColor = nil;
	UIColor *lightTextColor = nil;
	
	if(self.highlighted) {
		textColor = [UIColor whiteColor];
		lightTextColor = [UIColor whiteColor];
	} 
	else {
		textColor = [UIColor blackColor];
		lightTextColor = [UIColor grayColor];
		self.backgroundColor = [UIColor whiteColor];
	}
	
	if (!self.editing) {
		[textColor set];
		[resultWrapper.domainName drawInRect:CGRectMake(40.0f, 10.0f, 250.0f, rect.size.height) withFont:textFont lineBreakMode:UILineBreakModeWordWrap];
		
		[lightTextColor set];
		[resultWrapper.availability drawInRect:CGRectMake(40.0f, rect.size.height-25, 250.0f, 20.0f) withFont:aTextFont lineBreakMode:UILineBreakModeWordWrap];
		
		[resultWrapper.image drawInRect:CGRectMake(10.0f, 10.0f, 20.0f, 20.0f)];
	}

}

- (void)dealloc {

	[super dealloc];
}


@end
