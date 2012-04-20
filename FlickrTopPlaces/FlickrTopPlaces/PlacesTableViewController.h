//
//  PlacesTableViewController.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlacesModel.h"
#import "TitledTableViewController.h"

@interface PlacesTableViewController : TitledTableViewController

@property (nonatomic,strong) PlacesModel* topPlaces;

@end
