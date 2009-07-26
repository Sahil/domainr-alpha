//
//  MainViewController.h
//  Domainr
//
//  Created by Sahil Desai on 5/24/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CJSONDeserializer.h"

@class SettingsViewController;
@class FavouritesViewController;

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UINavigationBarDelegate> {
	NSUserDefaults			*prefs;
	SettingsViewController	*settingsController;
	FavouritesViewController *favouritesController;
	
	UINavigationController	*navController;
	UIToolbar				*toolbar;
	UITableView				*myTableView;
	UISearchBar				*mySearchBar;
	UIToolbar				*backgroundBar;
	UINavigationBar			*barForBorder;
	 
	NSData					*jsonData;
	NSURL					*jsonURL;
	NSMutableData			*receivedData;
	NSString				*jsonString;
	NSURLConnection			*theConnection;
	
	NSString				*searchQuery;
	NSMutableArray			*resultsArray;
	NSMutableArray			*favouritesArray;
	NSMutableArray			*resultObjectsArray;
	BOOL					loading;
	
	UIActivityIndicatorView *activityIndicator;
	UIBarButtonItem			*loadingView;
}

@property (nonatomic, retain) UITableView	*myTableView;
@property (nonatomic, retain) UIToolbar		*toolbar;
@property (nonatomic, retain) UISearchBar	*mySearchBar;
@property (nonatomic, retain) SettingsViewController *settingsController;

-(void)search:(id)sender;
-(BOOL)networkAvailable;
-(BOOL)isFavourite:(NSString *)domainName;
-(void)favourite:(NSString *)domainName;
-(BOOL)unfavourite:(NSString *)domainName;
- (void)syncFavourites;

@end
