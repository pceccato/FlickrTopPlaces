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

@implementation PlaceDetail
@synthesize name = _name;
@synthesize details = _details;
@synthesize params = _params;
@synthesize coordinate = _coordinate;

-(id) initWithNameAndParams:(NSString*)name params:(NSDictionary*) p
{
    if(self = [super init])
    {
        //
        // parse the name into place and details by splitting at the first comma found
        //
        NSRange searchRange;
        searchRange.location=(unsigned int)',';
        searchRange.length=1;
        NSRange foundRange = [name rangeOfCharacterFromSet:[NSCharacterSet characterSetWithRange:searchRange]];
        self.name = [name substringToIndex:foundRange.location]; // string up to the first comma
        self.details = [name substringFromIndex:foundRange.location + 2]; // string up to the first comma
        
        self.params = p;

        NSNumber* longitude = [self.params objectForKey:FLICKR_LONGITUDE];
        NSNumber* latitude  =  [self.params objectForKey:FLICKR_LATITUDE];

        _coordinate.latitude = [latitude doubleValue];
        _coordinate.longitude = [longitude doubleValue];
    }
    return self;
}

@end

@implementation PlacesModel

@synthesize sortedPlaces = _sortedPlaces;
@synthesize topPlaces = _topPlaces;

- (void) logFlickrResponse
{
    // see if we got anything back from flickr
    for (NSDictionary* place in self.topPlaces ) {
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
    self.topPlaces = [ FlickrFetcher topPlaces ];
    
    //
    // now parse the place names and place details and put it into an array sorted by alphabetical order
    //
    NSMutableArray * places = [[ NSMutableArray alloc] init ];
    for(NSDictionary* place in self.topPlaces)
    {        
        PlaceDetail* d = [[PlaceDetail alloc] initWithNameAndParams:[place objectForKey:FLICKR_PLACE_NAME] params:place ];

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
    //[ self logFlickrResponse ];
        
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

-(NSDictionary*) getPlaceParams:(int)atIndex    
{
    return [ self getPlace:atIndex ].params;
}

@end
