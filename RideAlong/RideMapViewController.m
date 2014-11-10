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
@property MKPointAnnotation *annotation;

@property NSArray *rides;
@end

@implementation RideMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.annotation = [[MKPointAnnotation alloc] init];
//    [self.annotation setCoordinate:newLocation];
//    [self.annotation setTitle:@"Starting Point"];
//    [self.annotation setSubtitle:self.mapSearchBar.text];
//    [self.mapView addAnnotation:self.annotation];
//    [self.mapView setRegion:MKCoordinateRegionMake(newLocation, MKCoordinateSpanMake(0.0025f, 0.0025f)) animated:YES];

}

- (void)makeAndPlaceRidePins
{
    for (PFObject *ride in self.rides)
    {

        self.annotation = [[MKPointAnnotation alloc] init];
        [self.annotation setTitle:@"Starting Point"];
//        [self.annotation setSubtitle:self.mapSearchBar.text];
//        [self.mapView addAnnotation:self.annotation];
//        [self.mapView setRegion:MKCoordinateRegionMake(newLocation, MKCoordinateSpanMake(0.0025f, 0.0025f)) animated:YES];
    }
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

@end
