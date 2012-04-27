//
//  ImageCache.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 27/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ImageCache.h"
#import "CoreData/CoreData.h"


const int maxCache = 10000000; 

@implementation ImageCache

     
+ (NSURL *)cachesDirectoryURL 
{
    //
    // TODO: make a subdir in here for caches so we can safely delete everything in it
    //
    NSFileManager* fm = [[NSFileManager alloc] init];
    return [[fm URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSURL *) getURL: (NSString*) image_id
{
    //
    // build a URL to the image
    //
    NSURL * directoryURL = [ ImageCache cachesDirectoryURL ];
    NSURL* imageURL = [ NSURL URLWithString:image_id relativeToURL:directoryURL];  
    
    return imageURL;
}
     
//
// looks up an image from the cache. returns nil if not found
//
+ (UIImage*) lookup: (NSString*) image_id
{
    UIImage* foundImage = nil;
    NSURL* imageURL = [ ImageCache getURL: image_id];
    
    NSData* imageData = [NSData dataWithContentsOfURL:imageURL];
    
    if( imageData != nil )
    {
        NSLog( @"image %@ found in cache", image_id );
        foundImage = [ UIImage imageWithData:imageData ];
    }
    else 
    {
        NSLog( @"image %@ NOT found in cache", image_id );
    }
    return foundImage;
}

//
// find the oldest file in the cache
//
+ (NSURL*) findOldest
{
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSURL* cacheURL = [ImageCache cachesDirectoryURL];
    // Enumerate the directory to find the earliest creation date (maybe we should use access date)
    // Ignore hidden files
    NSDirectoryEnumerator *dirEnumerator = [fm enumeratorAtURL:cacheURL
                                    includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLCreationDateKey,nil ] 
                                    options:NSDirectoryEnumerationSkipsHiddenFiles
                                    errorHandler:nil];
    
    
    NSDate* oldestDate = [NSDate distantFuture];
    NSURL* oldestURL = nil;
    
    // Enumerate the dirEnumerator results, each value is stored in allURLs
    for (NSURL *thisURL in dirEnumerator) 
    {
        NSDate *fileDate;
        [thisURL getResourceValue:&fileDate forKey:NSURLCreationDateKey error:NULL];
        if( fileDate )
        {
            //
            // TODO: do we need to check for non files... we don't want to delete directories
            //
            NSLog( @" %@ has date %@", thisURL, fileDate );
            if([fileDate compare:oldestDate] == NSOrderedAscending )
            {
                oldestDate = fileDate;
                oldestURL = thisURL;
            } 
        }
    }
    NSLog( @"Earliest entry is %@ %@:", oldestDate, oldestURL);
    return oldestURL;
}

//
// returns the size of the cache
//
+ (int) size
{
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSURL* cacheURL = [ImageCache cachesDirectoryURL];
    // Enumerate the directory to determine file size and creation date (maybe we should use access date)
    // Ignore hidden files
    NSDirectoryEnumerator *dirEnumerator = [fm enumeratorAtURL:cacheURL
                                    includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLCreationDateKey,NSURLNameKey, NSURLTotalFileAllocatedSizeKey, nil]
                                                       options:NSDirectoryEnumerationSkipsHiddenFiles
                                                  errorHandler:nil];
    
    //
    // size of the directory
    //
    int totalSize = 0;
    
    
    // Enumerate the dirEnumerator results, each value is stored in allURLs
    for (NSURL *thisURL in dirEnumerator) 
    {
        
        // Retrieve the file name. From NSURLNameKey, cached during the enumeration.
        NSNumber *fileSize;
        [thisURL getResourceValue:&fileSize forKey:NSURLTotalFileAllocatedSizeKey error:NULL];
        if( fileSize )
        {
            //
            // we don't care about things with no size attribute (eg directories)
            //
            totalSize += [fileSize intValue];
            NSLog( @" %@ has size %@", thisURL, fileSize );
        }
    }
    NSLog( @"total size of cache %@", [NSNumber numberWithInt: totalSize]);
    
    return totalSize;
    
}

//
// will delete any files from the cache if theres not enough room
// TODO: 
+ (void) ensureRoomInCache: (int) size
{
    int totalSize = [ImageCache size];

    if( totalSize + size < maxCache )
    {
        NSLog(@"there is sufficient room in the cache");
    }
    else 
    {
        NSFileManager* fm = [[NSFileManager alloc] init];
        //
        // loop through deleting files until there is enough space
        // or there are no files left
        //
        bool filesRemaining = YES;
        while( totalSize + size > maxCache && filesRemaining )
        {
            NSURL* oldestFile = [ImageCache findOldest];
            if( oldestFile )
            {
                //
                // delete it
                //
                NSLog(@"no room in cache... oldest file %@ will be deleted", oldestFile);
                [ fm removeItemAtURL:oldestFile error:nil ];
                totalSize = [ImageCache size];
            }
            else 
            {
                filesRemaining = NO;
            }
        }
    }
}

//
// stores image in cache. Deletes images if cache is full
//
+ (void) store: (UIImage*) image withId: (NSString*) image_id
{
    if( [ImageCache lookup:image_id] == nil )
    {
        //
        // its not in cache
        //
        NSData* imageData = UIImagePNGRepresentation(image);
        int size = imageData.length;
        [self ensureRoomInCache:size];
        NSURL* url = [ImageCache getURL:image_id];
        [imageData writeToURL:url atomically:YES];
        NSLog( @"image %@ saved to cache", image_id );        
    }
    else 
    {
        NSLog( @"image %@ is already in cache", image_id);
    }
}


@end


