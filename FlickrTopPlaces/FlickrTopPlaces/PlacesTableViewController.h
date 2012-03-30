//
//  PlacesTableViewController.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlacesModel.h"

@interface PlacesTableViewController : UITableViewController

@property (nonatomic,weak) PlacesModel* topPlaces;

@end
