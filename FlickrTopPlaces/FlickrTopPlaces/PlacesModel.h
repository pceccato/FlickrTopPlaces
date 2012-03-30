//
//  PlacesModel.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 30/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlacesModel : NSObject
@property (nonatomic,weak) NSArray* topPlaces;
-(void) loadFromFlickr;
-(int) getNumPlaces;
-(NSString*) getPlaceName: (int) atIndex;
-(NSString*) getLongPlaceName: (int) atIndex;




@end
