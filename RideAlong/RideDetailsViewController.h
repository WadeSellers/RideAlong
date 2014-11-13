//
//  RideDetailsViewController.h
//  RideAlong
//
//  Created by Wade Sellers on 11/4/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MyMKPointAnnotation.h"
#import "MyCustomPin.h"

@interface RideDetailsViewController : UIViewController
@property MyCustomPin *tappedAnnotation;

@end
