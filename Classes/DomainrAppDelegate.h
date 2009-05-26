//
//  DomainrAppDelegate.h
//  Domainr
//
//  Created by Sahil Desai on 5/24/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface DomainrAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	UINavigationController *navigationController;
	NetworkStatus internetConnectionStatus;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navigationController;
@property NetworkStatus internetConnectionStatus;

@end

