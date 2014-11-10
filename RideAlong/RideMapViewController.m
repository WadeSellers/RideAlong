//
//  RideMapViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/5/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RideMapViewController.h"
#import <MapKit/MapKit.h>

@interface RideMapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *rideMapView;

@property NSArray *rides;
@end

@implementation RideMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self refreshDisplay];
    [self makeAndPlaceRidePins];

}

- (void)refreshDisplay
{
    PFQuery *query = [PFQuery queryWithClassName:@"Ride"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error.userInfo);
            self.rides = [NSArray array];
        }
        else
        {
            self.rides = objects;
        }
    }];
}

- (void)makeAndPlaceRidePins
{
    for (PFObject *ride in self.rides)
    {
        PFGeoPoint *geoPoint = [ride objectForKey:@"geoStart"];
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setTitle:@"Starting Point"];
        annotation.coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
//        [self.annotation setSubtitle:self.mapSearchBar.text];
        [self.rideMapView addAnnotation:annotation];
        //[self.rideMapView setRegion:MKCoordinateRegionMake(newLocation, MKCoordinateSpanMake(0.0025f, 0.0025f)) animated:YES];
    }
}



@end
