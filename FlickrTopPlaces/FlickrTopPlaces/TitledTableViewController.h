//
//  TitledTableViewController.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 20/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

//
// a table view controller that displays a title in the navbar
//
@interface TitledTableViewController : UITableViewController

//
// title displayed in nav bar
//
@property (strong, nonatomic) NSString* title;
@end
