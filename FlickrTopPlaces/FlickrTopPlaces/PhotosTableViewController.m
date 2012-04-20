//
//  PhotosFromPlaceViewController.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 6/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotosTableViewController.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"



@interface PhotosTableViewController() 
@end

@implementation PhotosTableViewController

@synthesize photos = _photos;


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


@end
