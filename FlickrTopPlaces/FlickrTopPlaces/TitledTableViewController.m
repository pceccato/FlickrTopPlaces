//
//  TitledTableViewController.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 20/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TitledTableViewController.h"

@interface TitledTableViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *navBar;
@end

@implementation TitledTableViewController

@synthesize navBar = _navBar;
@synthesize title;


- (void)viewDidLoad
{
    [super viewDidLoad];
    if( [self.title length] != 0 )
        self.navBar.title = self.title;
}

- (void)viewDidUnload {
    [self setNavBar:nil];
    [super viewDidUnload];
}



@end
