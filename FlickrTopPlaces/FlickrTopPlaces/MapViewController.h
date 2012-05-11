//
//  MapViewController.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlacesModel.h"





@interface MapViewController : UIViewController

@property (atomic,weak) PlacesModel* places;

@end
