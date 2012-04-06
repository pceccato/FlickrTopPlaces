//
//  RecentTableViewController.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosModel.h"

@interface RecentTableViewController : UITableViewController
@property (nonatomic,strong) PhotosModel* recentPhotos;
@end
