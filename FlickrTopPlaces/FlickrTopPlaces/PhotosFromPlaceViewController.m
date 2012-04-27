//
//  PhotosFromPlaceViewController.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 18/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotosFromPlaceViewController.h"
#import "FlickrFetcher.h"

const int maxphotos = 50;

@interface PhotosFromPlaceViewController ()

@end

@implementation PhotosFromPlaceViewController
@synthesize place = _place;
//
// initialize contents of tableview from a background thread
//
- (void) loadPhotosForPlace
{
    //
    // do the blocking IO in a thread like so
    //
    dispatch_queue_t downloadQueue = dispatch_queue_create("flickr downloader", NULL );
    dispatch_async(downloadQueue, ^{
        
        //
        // first create an activity indicator to give the user some feedback whilst we hit the network
        // TODO: perhaps this should be part of our class or a common utility base class
        //
        UIActivityIndicatorView  *av = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        av.center = self.tableView.center;
        
        //
        // anything which updates the UI can only be done from main thread
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView addSubview:av ];
            [av startAnimating];
        });        
        
        
        self.photos = [ FlickrFetcher photosInPlace:self.place maxResults:maxphotos ]; 
        
        //
        // log the response from flickr
        //
        for (NSDictionary* photo in self.photos ) {
            for (id key in photo ) {
                
                NSLog(@"key: %@, value: %@", key, [photo objectForKey:key]);
                
            }
        }  
        //
        // anything which updates the UI can only be doen from main thread
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            [ self.tableView reloadData ];
            [av stopAnimating];
            [av removeFromSuperview];
        });
    });
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [ self loadPhotosForPlace ];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    [ super prepareForSegue:segue sender:sender ];
    NSString* identifier = [segue identifier];
    if ([identifier isEqualToString:@"ShowPhoto"]) {
        
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        int index = selectedRowIndex.row;
        
        //
        // grab the photo metadata put it in the recents list
        //
        NSDictionary* photo = [self.photos objectAtIndex: index];
        NSString* photoID = [photo objectForKey:FLICKR_PHOTO_ID];
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        
        //
        // defaults always returns non-mutable objects, convert iit to mutable so we can add recent photo
        //
        NSMutableArray* recentPhotos = [NSMutableArray arrayWithArray:[defaults objectForKey:@"recentPhotos"]];
        //
        // don't add duplicates
        //
        bool isDuplicate = NO;
        for (NSDictionary* recentPhoto in recentPhotos )
        {
            NSString* recentPhotoID = [recentPhoto objectForKey:FLICKR_PHOTO_ID];
            if( [recentPhotoID isEqualToString:photoID] )
                isDuplicate = YES;
        }
        //
        // stick it at the front of the array so most recent photos will be at the top
        if( !isDuplicate )
            [recentPhotos insertObject:photo atIndex:0];
        
        //
        // save it
        //
        [defaults setObject:recentPhotos forKey:@"recentPhotos"];
        [defaults synchronize];

    }
}

@end
