//
//  PlacesModel.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 30/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

//
// this is used for our alphabetically sorted list of places
//
@interface PlaceDetail : NSObject
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* details;
@property (nonatomic,weak) NSDictionary* params;
@property (nonatomic) CLLocationCoordinate2D coordinate;

-(id) initWithNameAndParams:(NSString*)name params:(NSDictionary*) p;
@end


//
// TODO: make this guy directly enumerable?
//
@interface PlacesModel : NSObject

-(void) loadFromFlickr;
-(int) getNumPlaces;
-(PlaceDetail*) getPlace: (int) atIndex;

@end
