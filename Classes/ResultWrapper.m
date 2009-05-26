//
//  ResultWrapper.m
//  Disqus
//
//  Created by Sahil Desai on 5/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#define AVAILABLE 0
#define MAYBE 1
#define TAKEN 2

#import "ResultWrapper.h"
#import "DomainrAppDelegate.h"

static UIImage *availableImage;
static UIImage *maybeImage;
static UIImage *takenImage;

@implementation ResultWrapper

@synthesize domainName;
@synthesize image;
@synthesize imageType;
@synthesize availability;

+ (void)initialize {
	if (self == [ResultWrapper class]) {
		availableImage = [[UIImage imageNamed:@"available.png"] retain];
		maybeImage =  [[UIImage imageNamed:@"maybe.png"] retain];
		takenImage =  [[UIImage imageNamed:@"taken.png"] retain];
	}
}

- (UIImage *)image {
	if (image == nil) {
			
		switch (imageType) {
			case AVAILABLE:
				image = availableImage;
				break;
			case MAYBE:
				image = maybeImage;
				break;
			case TAKEN:
				image = takenImage;
				break;
			default:
				break;
		}	
	}
	return image;
}

- (void)dealloc {
	[image release];
	[super dealloc];
}

@end
