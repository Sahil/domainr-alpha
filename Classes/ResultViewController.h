//
//  ResultViewController.h
//  Domainr
//
//  Created by Sahil Desai on 5/30/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResultViewController : UITableViewController {
	NSString *domain;
	NSString *status;
}

@property (nonatomic, retain) NSString *domain;
@property (nonatomic, retain) NSString *status;

@end
