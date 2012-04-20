//
//  PhotosFromPlaceViewController.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 6/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TitledTableViewController.h"

@interface PhotosTableViewController : TitledTableViewController

//
// all the photos to be displayed by this table view as returned by flickr...
// an array of PhotoInfo
//
@property (nonatomic,strong) NSArray* photos;


@end

