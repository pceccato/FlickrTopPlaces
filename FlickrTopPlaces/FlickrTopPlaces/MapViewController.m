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

@interface MapViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, atomic) NSArray* placeAnnotations;
@end

@implementation MapViewController
@synthesize places = _places;
@synthesize mapView = _mapView;
@synthesize placeAnnotations = _placeAnnotations;

- (NSArray*) generateAnnotations: (PlacesModel*) places
{
    NSMutableArray* annotations = [[NSMutableArray alloc] init];

    for( int i = 0; i < [places getNumPlaces]; i++)
    {
        MapAnnotation* a = [[MapAnnotation alloc] initWithPlace:[places getPlace:i] ];
        [annotations addObject:a];        
    }
    return annotations; 
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    //
    // add annotations to the map
    //
    self.placeAnnotations = [ self generateAnnotations:self.places ];
    [self.mapView addAnnotations:self.placeAnnotations];
    
    //
    // find centre of all annotations and determine the region we should display
    //
    MKCoordinateRegion r;
        
    double  minlong = 0, maxlong = 0, minlat = 0, maxlat = 0;
    
    for( MapAnnotation* a in self.placeAnnotations )
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
    r.center.latitude = maxlat + minlat; 
    r.center.longitude = maxlong +minlong; 
    r.span.latitudeDelta = maxlat - minlat;
    r.span.longitudeDelta = maxlong - minlong;
    
    [self.mapView setRegion:r];
   
    
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

@end
