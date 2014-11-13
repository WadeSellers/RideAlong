//
//  MyCustomPin.h
//  RideAlong
//
//  Created by Wade Sellers on 11/12/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Parse/Parse.h"
#import "MyMKPointAnnotation.h"


@interface MyCustomPin : MKPinAnnotationView
@property PFObject *rideObject;
@property MyMKPointAnnotation *myPointAnnotation;

@end
