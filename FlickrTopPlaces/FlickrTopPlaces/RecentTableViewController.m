//
//  RecentTableViewController.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 29/03/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecentTableViewController.h"

@implementation RecentTableViewController
@synthesize recentPhotos = _recentPhotos;

-(void) loadRecentPhotos
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * recents = [defaults objectForKey:@"recentPhotos"];
    
    self.photos = recents;
    
    [self.tableView reloadData ];

}

- (void)viewDidLoad
{
    //
    // set title here as navbar is updated in superclass
    //
    self.title = @"Recently Viewed";
    [super viewDidLoad];
    [ self loadRecentPhotos ];
}




@end
