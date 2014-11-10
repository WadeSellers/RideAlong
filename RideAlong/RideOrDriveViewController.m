//
//  RideOrDriveViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/8/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RideOrDriveViewController.h"
#import "RidesMainViewController.h"

@interface RideOrDriveViewController ()
@property int indexSetter;

@end

@implementation RideOrDriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onFindRideButtonPressed:(id)sender
{
    self.indexSetter = 0;
}

- (IBAction)onCreateRideButtonPressed:(id)sender
{
    self.indexSetter = 1;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navigationController = [segue destinationViewController];
    RidesMainViewController *ridesMainViewController = [[navigationController viewControllers]objectAtIndex:0];
    ridesMainViewController.indexSetter = self.indexSetter;
}


@end
