//
//  PlacesTableViewController.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "PhotosFromPlaceViewController.h"

@interface PlacesTableViewController()

@end

@implementation PlacesTableViewController

@synthesize topPlaces = _topPlaces;

#pragma mark - View lifecycle

//
// initialize contents of tableview from a background thread
//
- (void) loadTopPlaces
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
        //av.frame=CGRectMake(145, 160, 25, 25);
        //av.tag  = 1; // tag to identify the view
        av.center = self.tableView.center;
        
        //
        // anything which updates the UI can only be done from main thread
        //
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.tableView addSubview:av ];
            [av startAnimating];
        });
        //
        // now do the network request
        //
        [self.topPlaces loadFromFlickr];

        //
        // refresh tableview then cancel the activity indicator
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            if( self.tableView.window )
            {
                //
                // only if we are still on screen'
                //
                [ self.tableView reloadData ];
                //
                // can retrieve view like this
                //
                //UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.tableView viewWithTag:1];
                //
                // but we already have it
                [av stopAnimating];
                [av removeFromSuperview];
            }
        });
    });
}

- (void)viewDidLoad
{
    self.title = @"Flickr Top Places";
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    // initialize model
    PlacesModel * model = [[ PlacesModel alloc] init];
    self.topPlaces = model;
    

    //
    // load data from flickr
    //
    [ self loadTopPlaces ];
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Only one section.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [ self.topPlaces getNumPlaces ];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PlaceCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
    cell.textLabel.text = [ self.topPlaces getPlaceName:indexPath.row ];
    cell.detailTextLabel.text = [ self.topPlaces getPlaceDetails:indexPath.row ];
    return cell;
}

#pragma mark - Table view delegate


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSString* identifier = [segue identifier];
    if ([identifier isEqualToString:@"ShowPhotosFromPlace"]) {
        
        NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
        int index = selectedRowIndex.row;
        
        //
        // tell the drill down what place to load the photos for
        //
        PhotosFromPlaceViewController *destViewController = segue.destinationViewController;
        destViewController.place = [self.topPlaces getPlaceParams:index ];
        destViewController.title = [self.topPlaces getPlaceName:index ]; 
    }
}

@end
