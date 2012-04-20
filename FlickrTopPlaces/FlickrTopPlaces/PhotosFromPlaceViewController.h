//
//  PhotosFromPlaceViewController.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 18/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotosTableViewController.h"

@interface PhotosFromPlaceViewController : PhotosTableViewController

//
// place for which we will load the photos
//
@property (nonatomic,strong) NSDictionary* place;

@end
