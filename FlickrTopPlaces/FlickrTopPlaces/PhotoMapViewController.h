//
//  MapViewController.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlacesModel.h"

@class PhotoMapViewController;

@protocol PhotoMapViewControllerDelegate <NSObject>
- (UIImage *)mapViewController:(PhotoMapViewController *)sender imageForAnnotation:(id <MKAnnotation>)annotation;
@end

@interface PhotoMapViewController : UIViewController

//
// all the photos to be displayed by this map view as returned by flickr...
// an array of PhotoInfo
//
//
// place for which we will load the photos
//
@property (nonatomic,strong) NSDictionary* place;
@property (nonatomic, weak) id <PhotoMapViewControllerDelegate> delegate;
@end
