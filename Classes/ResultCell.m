//
//  ResultCell.m
//  Disqus
//
//  Created by Sahil Desai on 5/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "ResultCell.h"
#import "ResultWrapper.h"
#import "ResultView.h"
#import "DomainrAppDelegate.h"

@implementation ResultCell

@synthesize resultView;

- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		
		CGRect commentFrame = CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		resultView = [[ResultView alloc] initWithFrame:commentFrame];
		resultView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:resultView];		
    }
    return self;
}

- (void)setResultWrapper:(ResultWrapper *)newResultWrapper {
	resultView.resultWrapper = newResultWrapper;
}

- (ResultWrapper *)getResultWrapper {
	return resultView.resultWrapper;
}

- (void)dealloc {
	[resultView release];
    [super dealloc];
}


@end
