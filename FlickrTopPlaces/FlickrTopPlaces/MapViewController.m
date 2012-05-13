//
//  MapViewController.m
//  FlickrTopPlaces
//
//  Created by Paul Ceccato on 28/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import "MapAnnotation.h"
#import "PhotoMapViewController.h"

@interface MapViewController () <MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, atomic) NSArray* placeAnnotations;
@end

@implementation MapViewController
@synthesize places = _places;
@synthesize mapView = _mapView;
@synthesize placeAnnotations = _placeAnnotations;


- (NSArray*) generateAnnotations
{
    NSMutableArray* annotations = [[NSMutableArray alloc] init];

    for( int i = 0; i < [self.places getNumPlaces]; i++)
    {
        PlaceMapAnnotation* a = [[PlaceMapAnnotation alloc] initWithPlace:[self.places getPlace:i] ];
        [annotations addObject:a];        
    }
    return annotations;     
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mapView.delegate = self;
	
    //
    // add annotations to the map
    //
    self.placeAnnotations = [ self generateAnnotations ];
    [self.mapView addAnnotations:self.placeAnnotations];
    
    //
    // find centre of all annotations and determine the region we should display
    //
    MKCoordinateRegion r;
        
    double  minlong = 180, maxlong = -180, minlat = 90, maxlat = -90;
    
    for( PlaceMapAnnotation* a in self.placeAnnotations )
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
    r.span.latitudeDelta = (maxlat - minlat) *1.05;
    r.span.longitudeDelta = (maxlong - minlong) *1.05;
    
    [self.mapView setRegion:r];
    self.mapView.delegate = self;
    
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
    MKAnnotationView *aView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"MapVC"];
    if (!aView) 
    {
        aView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MapVC"];
        aView.canShowCallout = YES;
        
        //
        // UIButton for the drilldown
        //
        UIButton* button = [UIButton buttonWithType: UIButtonTypeDetailDisclosure]; 
        button.frame    = CGRectMake(0, 0, 30, 30);
        
        aView.rightCalloutAccessoryView = button;

        
    }
    
    aView.annotation = annotation;
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:nil];
    
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)aView
{
    UIImage *image = nil; //[self.delegate mapViewController:self imageForAnnotation:aView.annotation];
    
    [(UIImageView *)aView.leftCalloutAccessoryView setImage:image];
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"callout accessory tapped for annotation %@", [view.annotation title]);
    //
    // do the drilldown here...
    //
    [self performSegueWithIdentifier:@"PhotoMap" sender:view.annotation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    NSString* identifier = [segue identifier];
    if ([identifier isEqualToString:@"PhotoMap"]) 
    {
        PlaceMapAnnotation * a = sender;
        PhotoMapViewController *destViewController = segue.destinationViewController;
        
        //
        // pass the place metadata to the photo map view so it can load all the photos from the place
        //
//        destViewController.title = a.title;
        NSDictionary* place = a.place;
        destViewController.place = place;
    }
}

@end
