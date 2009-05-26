//
//  ResultView.h
//  Disqus
//
//  Created by Sahil Desai on 5/20/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResultWrapper;

@interface ResultView : UIView {	
	ResultWrapper *resultWrapper;
	BOOL highlighted;
	BOOL editing;
}

@property (nonatomic, retain) ResultWrapper *resultWrapper;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isEditing) BOOL editing;

@end
