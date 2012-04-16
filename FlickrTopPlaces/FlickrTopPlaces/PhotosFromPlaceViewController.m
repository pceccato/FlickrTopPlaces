//
//  PhotosFromPlaceViewController.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 6/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotosFromPlaceViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"

const int maxphotos = 50;

@interface PhotosFromPlaceViewController() 
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@property (strong, nonatomic) NSString* title;

@end

@implementation PhotosFromPlaceViewController
@synthesize navBar = _navBar;

@synthesize place = _place;
@synthesize photos = _photos;
@synthesize title;


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
    self.navBar.title = self.title;
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
    NSString* phototitle = [photo objectForKey:FLICKR_PHOTO_TITLE ];
    NSString* desc = [photo objectForKey:FLICKR_PHOTO_DESCRIPTION ];
    if( [phototitle length] == 0 )
    {
        //
        // use description for title if title is blank
        //
        phototitle = desc;
        desc = @"";
    }
    if( [phototitle length] == 0 )
    {
        //
        // still no title
        //
        phototitle = @"Unknown";
    }
    cell.textLabel.text = phototitle;
    cell.detailTextLabel.text = desc;
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSString* identifier = [segue identifier];
    if ([identifier isEqualToString:@"ShowPhoto"]) {
        
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        int index = selectedRowIndex.row;
        
        //
        // pass the photo metadata to the photo view
        //
        PhotoViewController *destViewController = segue.destinationViewController;
        NSDictionary* photo = [self.photos objectAtIndex: index];
        
        //
        // as well as the name of the photo from the tableview cell
        //
        UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:selectedRowIndex];
        destViewController.title = cell.textLabel.text;
        
        destViewController.photo = photo;
    }
}

- (void)viewDidUnload {
    [self setNavBar:nil];
    [super viewDidUnload];
}
@end
