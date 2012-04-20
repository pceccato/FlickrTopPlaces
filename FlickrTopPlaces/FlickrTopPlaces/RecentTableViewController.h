//
//  RecentTableViewController.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosModel.h"
#import "PhotosTableViewController.h"

@interface RecentTableViewController : PhotosTableViewController

@property (nonatomic,strong) PhotosModel* recentPhotos;

@end
