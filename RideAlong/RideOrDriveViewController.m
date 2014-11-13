//
//  RideOrDriveViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/8/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RideOrDriveViewController.h"
#import "RideDetailsViewController.h"

@interface RideOrDriveViewController ()

@end

@implementation RideOrDriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationUUIDKey"]);
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (IBAction)unwindFromCompleteNewRide:(UIStoryboardSegue *)segue
{
    
}

- (IBAction)unwindFromBookLift:(UIStoryboardSegue *)segue
{
    
}

@end
