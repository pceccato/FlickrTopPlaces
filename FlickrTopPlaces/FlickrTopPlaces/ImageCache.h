//
//  ImageCache.h
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FlickrFetcher.h"


//
// keeps a cache of photos in our app's sandbox.
// when cache is full the oldest entries will be deleted until there is room
//
@interface ImageCache : NSObject

//
// looks up an image from the cache. returns nil if not found
//
+ (UIImage*) lookup: (NSString*) image_id;

//
// looks up an image in the cache. If not found fetch it from flickr
//
+ (UIImage*) lookupAndFetchIfNotCached: (NSDictionary*) image_info withFormat: (FlickrPhotoFormat) f;

//
// stores image in cache. Deletes images if cache is full
//
+ (void) store: (UIImage*) image withId: (NSString*) image_id;

@end
