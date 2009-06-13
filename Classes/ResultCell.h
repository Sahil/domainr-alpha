//
//  ResultCell.h
//  Disqus
//
//  Created by Sahil Desai on 5/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResultWrapper;
@class ResultView;

@interface ResultCell : UITableViewCell {
	ResultView *resultView;
}

- (void)setResultWrapper:(ResultWrapper *)newResultWrapper;
- (ResultWrapper *)getResultWrapper;

@property (nonatomic, retain) ResultView *resultView;

@end
