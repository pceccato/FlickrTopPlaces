//
//  MapAnnotation.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapAnnotation.h"
#import <MapKit/MapKit.h>


@implementation MapAnnotation

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;

- (id) initWithPlace:(PlaceDetail*) place
{
    self = [super init];
    
    _title = place.name;
    _subtitle = place.details;
    _coordinate = place.coordinate;
    
    
    return self;
    
}
@end
