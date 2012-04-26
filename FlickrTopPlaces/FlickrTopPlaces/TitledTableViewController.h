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
// probably redundant unless we can add some more functionaltiy
// as I just learned the view hasa navigationItem property so I do not need 
// need to wire up the navbar explicitly
//
@interface TitledTableViewController : UITableViewController

//
// title displayed in nav bar
//
@property (strong, nonatomic) NSString* title;
@end
