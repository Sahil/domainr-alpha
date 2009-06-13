//
//  FavouritesViewController.h
//  Domainr
//
//  Created by Sahil Desai on 5/31/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FavouritesViewController : UITableViewController {
	NSUserDefaults *prefs;
	NSMutableArray *favouritesArray;
}

@end
