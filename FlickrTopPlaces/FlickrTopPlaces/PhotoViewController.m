//
//  PhotoViewController.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 9/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"

@interface PhotoViewController()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation PhotoViewController
@synthesize imageView;
@synthesize scrollView;
@synthesize photo = _photo;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

- (void) loadPhoto
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
        av.center = self.imageView.center;
        
        //
        // anything which updates the UI can only be done from main thread
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.scrollView addSubview:av ];
            [av startAnimating];
        });

        //
        // get the url for this photo and use it to create the UIimage
        //
        NSURL* url = [FlickrFetcher urlForPhoto:self.photo format:FlickrPhotoFormatLarge];
        UIImage* image = [ UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        
        //
        // update imageview then cancel activity indicator
        //
        dispatch_async(dispatch_get_main_queue(), ^{

            self.imageView.image = image;
            self.scrollView.contentSize = self.imageView.image.size;
            //
            // set the imageView to show the entire image
            //
            self.imageView.frame = CGRectMake( 0, 0, self.imageView.image.size.width, self.imageView.image.size.height); 
            

            [av stopAnimating];
            [av removeFromSuperview];
        });
    });
    
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadPhoto];
    

}


- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
