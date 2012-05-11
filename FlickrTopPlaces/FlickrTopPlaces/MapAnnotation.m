//
//  MapAnnotation.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapAnnotation.h"
#import <MapKit/MapKit.h>
#import "ImageCache.h"

@implementation PlaceMapAnnotation

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;
@synthesize place = _place;

- (id) initWithPlace:(PlaceDetail*) place
{
    self = [super init];
    
    _title = place.name;
    _subtitle = place.details;
    _coordinate = place.coordinate;
    _place = place.params;
    
    return self;
    
}
@end


@implementation PhotoMapAnnotation
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize coordinate = _coordinate;
@synthesize photoinfo = _photoinfo;
@synthesize image = _image;

- (id) initWithPhoto:(NSDictionary*) photo
{
    self = [super init];
    self.photoinfo = photo;
    
    return self;
    
}

- (UIImage*) image
{
    //
    // TODO do we need to distinguish the various image formats in the cache?
    //
    _image = [ImageCache lookupAndFetchIfNotCached:self.photoinfo withFormat:FlickrPhotoFormatSquare ];
    return _image;
    
}

- (CLLocationCoordinate2D) coordinate
{
    NSNumber* longitude = [self.photoinfo objectForKey:FLICKR_LONGITUDE];
    NSNumber* latitude  =  [self.photoinfo objectForKey:FLICKR_LATITUDE];
    
    CLLocationCoordinate2D c;
    c.latitude = [latitude doubleValue];
    c.longitude = [longitude doubleValue];
    return c;
}

- (NSString*) title
{
    NSString* title = [self.photoinfo objectForKey:FLICKR_PHOTO_TITLE ];
    if( [title length] == 0 )
    {
        //
        // use description for title if title is blank
        //
        title = [self.photoinfo objectForKey:FLICKR_PHOTO_DESCRIPTION ];
    }
    if( [title length] == 0 )
    {
        //
        // still no title
        //
        title = @"Unknown";
    }
    return title;
}

- (NSString*) subtitle
{
    NSString* title = [self.photoinfo objectForKey:FLICKR_PHOTO_TITLE ];
    NSString* desc = [self.photoinfo objectForKey:FLICKR_PHOTO_DESCRIPTION ];
    if( [title length] == 0 )
    {
        //
        // use description for title if title is blank
        //
        title = [self.photoinfo objectForKey:FLICKR_PHOTO_DESCRIPTION ];
        desc = @"";
    }
    return desc;
}


@end
