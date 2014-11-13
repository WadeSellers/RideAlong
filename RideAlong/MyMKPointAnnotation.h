//
//  MyMKPointAnnotation.h
//  RideAlong
//
//  Created by Wade Sellers on 11/12/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface MyMKPointAnnotation : MKPointAnnotation
@property PFObject *rideObject;

@end
