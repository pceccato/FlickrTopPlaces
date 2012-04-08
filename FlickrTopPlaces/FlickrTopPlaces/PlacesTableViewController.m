//
//  PlacesTableViewController.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "PhotosFromPlaceViewController.h"


@implementation PlacesTableViewController

@synthesize topPlaces = _topPlaces;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

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
            [ self.tableView reloadData ];
            //
            // can retrieve view like this
            //
            //UIActivityIndicatorView *tmpimg = (UIActivityIndicatorView *)[self.tableView viewWithTag:1];
            //
            // but we already have it
            [av stopAnimating];
            [av removeFromSuperview];
        });
    });
}

- (void)viewDidLoad
{
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

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
    }
}

@end
