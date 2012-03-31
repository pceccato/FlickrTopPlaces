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
    NSString* longName = [self getLongPlaceName:atIndex ];
    
    // find first comma
    NSRange searchRange;
    searchRange.location=(unsigned int)',';
    searchRange.length=1;
    NSRange foundRange = [longName rangeOfCharacterFromSet:[NSCharacterSet characterSetWithRange:searchRange]];
    
    return [longName substringToIndex:foundRange.location]; // return string up to the first comma
    
}

-(NSString*) getLongPlaceName: (int) atIndex
{
    NSString* name = @"";
    if( atIndex < self.getNumPlaces )
    {
        NSDictionary* place = [ self.topPlaces objectAtIndex:atIndex ];
        name = [place objectForKey:@"_content"]; 
        


        

    }
    
    return name;
}


@end
