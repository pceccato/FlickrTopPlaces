//
//  PhotosFromPlaceViewController.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 6/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotosFromPlaceViewController : UITableViewController

//
// place for which we will load the photos
//
@property (nonatomic,strong) NSDictionary* place;

//
// all the photos for the above place as returned by flickr
//
@property (nonatomic,strong) NSArray* photos;

@end

