//
//  ResultWrapper.h
//  Disqus
//
//  Created by Sahil Desai on 5/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultWrapper : NSObject {
	NSString	*domainName;
	NSString	*availability;
	UIImage		*image;
	int			imageType;
}

@property (nonatomic, retain) NSString	*domainName;
@property (nonatomic, retain) NSString	*availability;
@property (nonatomic, retain) UIImage	*image;
@property (readwrite, assign) int imageType;

@end
