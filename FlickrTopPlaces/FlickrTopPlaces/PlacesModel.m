//
//  PlacesModel.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 30/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlacesModel.h"
#import "FlickrFetcher.h"


//
// private properties go in here
//
@interface PlacesModel ()
@property (nonatomic,strong) NSArray* sortedPlaces;
@property (nonatomic,strong) NSArray* topPlaces;
@end

//
// this is used for our alphabetically sorted list of places
//
@interface PlaceDetail : NSObject
@property (nonatomic,strong) NSString* name;
@property (nonatomic,strong) NSString* details;
@property (nonatomic,weak) NSDictionary* params;
@end


@implementation PlaceDetail
@synthesize name = _name;
@synthesize details = _details;
@synthesize params = _params;
@end

@implementation PlacesModel

@synthesize sortedPlaces = _sortedPlaces;

@synthesize topPlaces = _topPlaces;

- (void) logFlickrResponse
{
    // see if we got anything back from flickr
    for (NSDictionary* place in _topPlaces ) {
        for (id key in place ) {
            
            NSLog(@"key: %@, value: %@", key, [place objectForKey:key]);
            
        }
    }   
}

- (void) getTopPlacesFromFlickr
{
    //
    // make request to flickr
    //
    _topPlaces = [ FlickrFetcher topPlaces ];

    
    //
    // now parse the place names and place details and put it into an array sorted by alphabetical order
    //
    NSMutableArray * places = [[ NSMutableArray alloc] init ];
    for(NSDictionary* place in _topPlaces)
    {
        //
        // place details are found under the content key
        //
        NSString* unparsedName = [place objectForKey:FLICKR_PLACE_NAME];
        
        //
        // parse the name into place and details by splitting at the first comma found
        //
        NSRange searchRange;
        searchRange.location=(unsigned int)',';
        searchRange.length=1;
        NSRange foundRange = [unparsedName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithRange:searchRange]];
        
        PlaceDetail* d = [[PlaceDetail alloc] init];
        d.name = [unparsedName substringToIndex:foundRange.location]; // string up to the first comma
        d.details = [unparsedName substringFromIndex:foundRange.location + 2]; // string up to the first comma
        d.params = place;
        
        //
        // put it into our temporary array
        //
        [places addObject:d];
    }
        
    //
    // now sort the array by place name
    //
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    self.sortedPlaces = [places sortedArrayUsingDescriptors:sortDescriptors];
    
    //
    // log it
    //
    [ self logFlickrResponse ];
        
}

- (void) loadFromFlickr
{
    [self getTopPlacesFromFlickr ];
}

-(int) getNumPlaces
{
    return [ self.sortedPlaces count ];
}

-(PlaceDetail*) getPlace: (int) atIndex
{
    PlaceDetail* d = nil;
    if( atIndex < self.getNumPlaces )
    {
        d =  [ self.sortedPlaces objectAtIndex:atIndex ];
    }
    return d; 
}

//
// get the place name, usually its the first field separated by a comma
//
-(NSString*) getPlaceName: (int) atIndex
{
    return [self getPlace:atIndex ].name;
}


//
// the remaining place details found AFTER the first comma
//
-(NSString*) getPlaceDetails: (int) atIndex
{
    return [self getPlace:atIndex ].details;   
}

-(NSDictionary*) getPlaceParams:(int)atIndex    
{
    return [ self getPlace:atIndex ].params;
}

@end
