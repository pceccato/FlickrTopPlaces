//
//  PhotoViewController.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 9/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"
#import "FlickrFetcher.h"
#import "ImageCache.h"

@interface PhotoViewController() <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation PhotoViewController
@synthesize imageView;
@synthesize scrollView;

@synthesize photo = _photo;

- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
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
        // get the photo from the cache, if not cached then request from flickr
        //
        UIImage* image = [ ImageCache lookupAndFetchIfNotCached:self.photo withFormat:FlickrPhotoFormatLarge ];
        
        //
        // update imageview then cancel activity indicator
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            if( self.imageView.window )
            {
                //
                // only bother doing all this if we are still displayed on the screen
                // the user my have navigated away
                //
                self.imageView.image = image;
                self.scrollView.contentSize = self.imageView.image.size;
                //
                // set the imageView to show the entire image
                //
                CGRect image = CGRectMake( 0, 0, self.imageView.image.size.width, self.imageView.image.size.height); 
                self.imageView.frame = image;
                //
                // we want to have no unused space so the zoom rect must have the same aspect as the scrollviews frame
                // so the shortest edge of the image should correspond to longest side of the frame
                //
                CGRect frame = self.scrollView.frame;
                
                float ratio = 0;
                float scrollHeight = 0;
                float scrollWidth = 0;
                if( frame.size.width > frame.size.height )
                {
                    // landscape frame
                    ratio = frame.size.height / frame.size.width;
                    if( image.size.width > image.size.height )
                    {
                        // landscape image
                        scrollWidth = image.size.width;
                        scrollHeight = scrollWidth * ratio;
                    }
                    else
                    {
                        // portrait image
                        scrollWidth  = image.size.width;
                        scrollHeight = scrollWidth * ratio;
                    }
                }
                else
                {
                    // portrait frame
                    ratio = frame.size.width / frame.size.height;
                    if( image.size.width > image.size.height )
                    {
                        // landscape image
                        scrollHeight = image.size.height;
                        scrollWidth = scrollHeight * ratio;
                    }
                    else
                    {
                        // portrait image
                        scrollWidth  = image.size.width;
                        scrollHeight = scrollWidth * ratio;
                    }
                }

                CGRect zoomRect = CGRectMake( 0, 0, scrollWidth, scrollHeight);
                
                
                [self.scrollView zoomToRect:zoomRect  animated:TRUE ];
                
                [av stopAnimating];
                [av removeFromSuperview];
            }
        });
    });
    
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.title;
    
    [self loadPhoto];
    
    //
    // hook up the scrolling delegate
    //
    self.scrollView.delegate = self;
}

//
// do geometry calculations here...
//
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated ];
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
