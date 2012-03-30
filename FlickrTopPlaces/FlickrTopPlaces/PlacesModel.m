//
//  PlacesModel.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 30/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlacesModel.h"
#import "FlickrFetcher.h"

@implementation PlacesModel

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
    _topPlaces = [ FlickrFetcher topPlaces ];
    [ self logFlickrResponse ];
    
}

- (void) loadFromFlickr
{
    [self getTopPlacesFromFlickr ];
}

-(int) getNumPlaces
{
    return [ self.topPlaces count ];
}

-(NSString*) getPlaceName: (int) atIndex
{
    NSString* name = @"";
    if( atIndex < self.getNumPlaces )
    {
        NSDictionary* place = [ self.topPlaces objectAtIndex:atIndex ];
        name = [place objectForKey:@"_content"];        
    }
    
    return name;
    
}
-(NSString*) getLongPlaceName: (int) atIndex
{
    return [self getPlaceName: atIndex];
    
}


@end
