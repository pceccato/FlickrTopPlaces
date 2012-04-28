//
//  MapAnnotation.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "PlacesModel.h"

@interface MapAnnotation : NSObject<MKAnnotation>

@property (readonly) CLLocationCoordinate2D coordinate;
@property (readonly) NSString *title;
@property (readonly) NSString *subtitle;

- (id) initWithPlace:(PlaceDetail*) place;

@end
