//
//  RideMapViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/5/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RideMapViewController.h"
#import "RideDetailsViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyCustomPin.h"

@interface RideMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *rideMapView;
@property CLLocationManager *locationManager;
@property MKPointAnnotation *myPin;
@property NSArray *rides;
@property PFObject *resortObject;
@property NSMutableArray *annotationsArray;
@end

@implementation RideMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.annotationsArray = [NSMutableArray array];
    self.rideMapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }

    [self.locationManager startUpdatingLocation];

    self.myPin = [[MKPointAnnotation alloc] init];

    self.myPin.title = @"YAY";
    [self.rideMapView addAnnotation:self.myPin];

    self.rideMapView.delegate = self;

    [self refreshDisplay];

}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}


- (void)refreshDisplay
{
    PFQuery *query = [PFQuery queryWithClassName:@"Ride"];
    //[query whereKey:@"endName" equalTo:self.resortObject[@"name"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error.userInfo);
            self.rides = [NSArray array];
        }
        else
        {
            self.rides = objects;
//            NSLog(@"rides: %@", self.rides);
            [self makeAndPlaceRidePins];
        }
    }];
}

- (void)makeAndPlaceRidePins
{
    for (PFObject *ride in self.rides)
    {
        PFGeoPoint *tempGeoPoint = [ride objectForKey:@"geoStart"];

        CLLocationCoordinate2D annotationCoordinate = CLLocationCoordinate2DMake(tempGeoPoint.latitude, tempGeoPoint.longitude);

        MyMKPointAnnotation *annotation= [[MyMKPointAnnotation alloc] init];
        annotation.coordinate = annotationCoordinate;
        annotation.title = ride[@"startName"];
        annotation.rideObject = ride;

        [self.annotationsArray addObject:annotation];
        [self.rideMapView setRegion:MKCoordinateRegionMake(annotationCoordinate, MKCoordinateSpanMake(5.0f, 5.0f)) animated:YES];
            NSLog(@"rides: %@", ride);
            NSLog(@"mypin.coordinate: %f, %f", self.myPin.coordinate.latitude, self.myPin.coordinate.longitude);
    }
    [self.rideMapView showAnnotations:self.annotationsArray animated:YES];
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MyCustomPin *pin = [[MyCustomPin alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPinId"];
    pin.enabled = YES;
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.myPointAnnotation = annotation;

    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
     [self performSegueWithIdentifier:@"rideDetailsSegue" sender:view];
}

//Need to figure out how to know which annotation was selected and the ride object it originally came from

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MyCustomPin *)sender
{
    RideDetailsViewController *rideDetailsViewController = [segue destinationViewController];
    rideDetailsViewController.tappedAnnotation = sender;
}

@end
