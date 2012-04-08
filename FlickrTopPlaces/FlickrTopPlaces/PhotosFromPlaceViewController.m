//
//  PhotosFromPlaceViewController.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 6/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotosFromPlaceViewController.h"
#import "FlickrFetcher.h"

const int maxphotos = 40;

@implementation PhotosFromPlaceViewController

@synthesize place = _place;
@synthesize photos = _photos;


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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //
    // load data from flickr
    //
    [ self loadPhotosForPlace ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Only one section.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [ self.photos count ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotoCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary* photo = [self.photos objectAtIndex:indexPath.row];
    NSString* title = [photo objectForKey:FLICKR_PHOTO_TITLE ];
    NSString* desc = [photo objectForKey:FLICKR_PHOTO_DESCRIPTION ];
    if( [title length] == 0 )
    {
        //
        // use description for title if title is blank
        //
        title = desc;
        desc = @"";
    }
    if( [title length] == 0 )
    {
        //
        // still no title
        //
        title = @"Unknown";
    }
    cell.textLabel.text = title;
    cell.detailTextLabel.text = desc;
    return cell;
}

@end
