//
//  RideOrDriveViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/8/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RideOrDriveViewController.h"
#import "RideDetailsViewController.h"
#import "MyCustomPin.h"

@interface RideOrDriveViewController ()
@property MyCustomPin *ridePin;

@end

@implementation RideOrDriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationUUIDKey"]);
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];

//    NSLog(@"dadada %@", self.ridePin.myPointAnnotation.rideObject);

}

- (void)passengerSetupAndSave
{
    self.ridePin.myPointAnnotation.rideObject[@"passenger"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationUUIDKey"];

    //NSLog(@"dadada %@", self.rideObject);
    [self.ridePin.myPointAnnotation.rideObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", [error userInfo]);
        }
    }];
}

- (IBAction)unwindFromCompleteNewRide:(UIStoryboardSegue *)segue
{

}

- (IBAction)unwindFromBookLift:(UIStoryboardSegue *)segue
{
    RideDetailsViewController *rideDetailsViewController = [segue sourceViewController];
    self.ridePin = rideDetailsViewController.tappedAnnotation;
    NSLog(@"dadada %@", self.ridePin.myPointAnnotation.rideObject);
    [self passengerSetupAndSave];
}

@end
