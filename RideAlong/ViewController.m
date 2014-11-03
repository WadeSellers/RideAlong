//
//  ViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/3/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController () <CLLocationManagerDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
}

// Location Manager Delegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MyPinID"];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.image = [UIImage imageNamed:@"PinImage"];

    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    CLLocationCoordinate2D center = view.annotation.coordinate;

    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;

    MKCoordinateRegion region;
    region.center = center;
    region.span = span;

    [self.mapView setRegion:region animated:YES];
    
}

@end
