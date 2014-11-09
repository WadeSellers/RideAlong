//
//  CreateRideMapViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/8/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "CreateRideMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface CreateRideMapViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mapSearchTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation CreateRideMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView.region

}

- (IBAction)onAddButtonPressed:(UIButton *)sender
{

}


@end
