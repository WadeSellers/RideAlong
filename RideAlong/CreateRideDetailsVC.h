//
//  CreateRideViewController.h
//  RideAlong
//
//  Created by Wade Sellers on 11/4/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface CreateRideDetailsVC : UIViewController

@property MKPointAnnotation *startingMKPointAnnotation;
@property PFObject *resortObject;

@end
