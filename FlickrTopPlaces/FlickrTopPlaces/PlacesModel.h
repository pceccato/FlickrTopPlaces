//
//  PlacesModel.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 30/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlacesModel : NSObject


-(void) loadFromFlickr;
-(int) getNumPlaces;
-(NSString*) getPlaceName: (int) atIndex;
-(NSString*) getPlaceDetails: (int) atIndex;



@end
