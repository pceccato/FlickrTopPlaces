//
//  TitledTableViewController.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 20/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TitledTableViewController.h"


@implementation TitledTableViewController


@synthesize title;


- (void)viewDidLoad
{
    [super viewDidLoad];
    if( [self.title length] != 0 )
        self.navigationItem.title = self.title;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}



@end
