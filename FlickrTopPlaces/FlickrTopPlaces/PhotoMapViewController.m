//
//  MapViewController.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoMapViewController.h"
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"
#import "PlacesModel.h"
#import "PhotoViewController.h"
#include "FlickrFetcher.h"

@interface PhotoMapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, atomic) NSArray* annotations;

@end

@implementation PhotoMapViewController
@synthesize place = _place;
@synthesize mapView = _mapView;
@synthesize annotations = _annotations;
@synthesize delegate = _delegate;
@synthesize photos = _photos;

- (void)updateMapView
{
    if (self.mapView.annotations) [self.mapView removeAnnotations:self.mapView.annotations];
    if (self.annotations) [self.mapView addAnnotations:self.annotations];
}

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
        av.center = self.mapView.center;
        
        //
        // anything which updates the UI can only be done from main thread
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.mapView addSubview:av ];
            [av startAnimating];
            [self updateMapView];
        });        
        
        
        //
        // request photos from place from flickr if we don't have them
        //
        if( !self.photos )
        {
            self.photos = [ FlickrFetcher photosInPlace:self.place maxResults:50 ]; 
        }
        //
        // convert them into annotations
        //
        self.annotations = [ self generateAnnotations ];
        
        //
        // anything which updates the UI can only be doen from main thread
        //
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            // find centre of all annotations and determine the region we should display
            //
            MKCoordinateRegion r;
            
            double  minlong = 180, maxlong = -180, minlat = 90, maxlat = -90;
            
            for( PhotoMapAnnotation* a in self.annotations )
            {
                
                if( a.coordinate.latitude > maxlat)
                    maxlat = a.coordinate.latitude;
                
                if( a.coordinate.latitude < minlat)
                    minlat = a.coordinate.latitude;
                
                if( a.coordinate.longitude > maxlong )
                    maxlong = a.coordinate.longitude;
                if( a.coordinate.longitude < minlong )
                    minlong = a.coordinate.longitude;
                
            }
            
            //
            // average centre... perhaps
            r.center.latitude = (maxlat + minlat)/2; 
            r.center.longitude = (maxlong +minlong)/2; 
            //
            // pad by 5 %
            //
            r.span.latitudeDelta = (maxlat - minlat) * 1.05;
            r.span.longitudeDelta = (maxlong - minlong) * 1.05;
            
            [self.mapView setRegion:r];
            self.mapView.delegate = self;
            //
            // add annotations to the map
            //
            [self updateMapView];
            
            [av stopAnimating];
            [av removeFromSuperview];
        });
    });
}

- (NSArray*) generateAnnotations
{
    NSMutableArray* annotations = [[NSMutableArray alloc] init];
    
    for( NSDictionary *photo in self.photos )
    {
        PhotoMapAnnotation* a = [[PhotoMapAnnotation alloc] initWithPhoto:photo ];
        [annotations addObject:a];  
    }
    return annotations; 
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
    
    [self loadPhotosForPlace ];
	
   
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"PhotoMapVC"];
    if (!aView) 
    {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"PhotoMapVC"];
        aView.canShowCallout = YES;
        
        //
        // UIButton for the drilldown
        //
        UIButton* button = [UIButton buttonWithType: UIButtonTypeDetailDisclosure]; 
        button.frame    = CGRectMake(0, 0, 30, 30);
        
        aView.rightCalloutAccessoryView = button;
        aView.leftCalloutAccessoryView = [[ UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30) ];     
    }
    
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    //
    // todo get image
    //
    UIImage *image = nil; //[self.delegate mapViewController:self imageForAnnotation:aView.annotation];
    
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
    //
    // do the drilldown here...
    //
    [self performSegueWithIdentifier:@"ViewPhotoFromMap" sender:view.annotation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSString* identifier = [segue identifier];
    if ([identifier isEqualToString:@"ViewPhotoFromMap"]) 
    {
        PhotoMapAnnotation * a = sender;
        PhotoViewController *destViewController = segue.destinationViewController;
        
        //
        // pass the photo metadata to the photo view so it can load it
        // as well as the name of the photo from the annotation
        //
        destViewController.title = a.title;
        destViewController.photo = a.photoinfo;
    }
}

@end
