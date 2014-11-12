//
//  RideMapViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/5/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RideMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "RideDetailsViewController.h"

@interface RideMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *rideMapView;
@property CLLocationManager *locationManager;
@property MKPointAnnotation *myPin;

@property NSArray *rides;
@end

@implementation RideMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.rideMapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];

    self.myPin = [[MKPointAnnotation alloc] init];

    self.myPin.title = @"YAY";
    [self.rideMapView addAnnotation:self.myPin];

    self.rideMapView.delegate = self;
    [self refreshDisplay];

}




- (void)refreshDisplay
{
    PFQuery *query = [PFQuery queryWithClassName:@"Ride"];
    //[query whereKey:@"endName" equalTo:@"Arapahoe Basin"];
    [query whereKey:@"endName" equalTo:self.resortObject[@"name"]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error.userInfo);
            self.rides = [NSArray array];
        }
        else
        {
            self.rides = objects;
            NSLog(@"rides: %@", self.rides);
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

        self.myPin.coordinate = annotationCoordinate;
        [self.rideMapView addAnnotation:self.myPin];
        [self.rideMapView setRegion:MKCoordinateRegionMake(annotationCoordinate, MKCoordinateSpanMake(0.1f, 0.1f)) animated:YES];
    }
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

//    MKPinAnnotationView *pin = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier:@"MyPinId"];
//    if (pin == nil)
//    {
        MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPinId"];
        pin.enabled = YES;
        pin.canShowCallout = YES;
//        pin.image = [UIImage imageNamed:@"locale.png"]; // could use MKAnnotationView instead of MKPinAnnotationView?

        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    }
//    else {
//    pin.annotation = annotation;
//    }

return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
     // use the annotation view as the sender

    RideDetailsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FILL ME IN"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MKAnnotationView *)sender
{
    if ([segue.identifier isEqualToString:@"RideDetailsVC"])
    {
        RideDetailsViewController *destinationViewController = segue.destinationViewController;

        // grab the annotation from the sender

        destinationViewController.resortObject = self.resortObject;
    } else {
        NSLog(@"WTF?");
    }
}









//    NSString *reuseId = @"standardPin";
//
//    MKPinAnnotationView *pinAnnotation = (MKPinAnnotationView *)[sender dequeueReusableAnnotationViewWithIdentifier:reuseId];
//    if (pinAnnotation == nil)
//    {
//        pinAnnotation.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeInfoDark];
//        pinAnnotation.canShowCallout = YES;
//    }
//    pinAnnotation.annotation = annotation;
//    return pinAnnotation;

@end
