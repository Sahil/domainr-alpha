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
#define TLD 3

#import "ResultWrapper.h"
#import "DomainrAppDelegate.h"

static UIImage *availableImage;
static UIImage *maybeImage;
static UIImage *takenImage;
static UIImage *tldImage;

@implementation ResultWrapper

@synthesize domainName;
@synthesize image;
@synthesize imageType;
@synthesize availability;

- (void)dealloc {
	[image release];
	[super dealloc];
}

+ (void)initialize {
	if (self == [ResultWrapper class]) {
		availableImage = [[UIImage imageNamed:@"available.png"] retain];
		maybeImage =  [[UIImage imageNamed:@"maybe.png"] retain];
		takenImage =  [[UIImage imageNamed:@"taken.png"] retain];
		tldImage =  [[UIImage imageNamed:@"tld.png"] retain];
	}
}

- (id) initWithCoder: (NSCoder *)coder
{
	if (self = [super init])
	{
		[self setDomainName:	[coder decodeObjectForKey:@"name"]];
		[self setImage:			[coder decodeObjectForKey:@"image"]];
//		[self setImageType:		[coder decodeObjectForKey:@"imageType"]];
		[self setAvailability:	[coder decodeObjectForKey:@"availability"]];
	}
	return self;
}

- (void) encodeWithCoder: (NSCoder *)coder
{
	[coder encodeObject: domainName		forKey:@"name"];
	[coder encodeObject: image			forKey:@"image"];
//	[coder encodeObject: imageType		forKey:@"imageType"];
	[coder encodeObject: availability	forKey:@"availability"];
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
			case TLD:
				image = tldImage;
				break;
			default:
				break;
		}	
	}
	return image;
}



@end
