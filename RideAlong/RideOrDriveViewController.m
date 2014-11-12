//
//  RideOrDriveViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/8/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RideOrDriveViewController.h"
#import "RidesMainViewController.h"
#import "ProfileViewController.h"

@interface RideOrDriveViewController ()
@property int createRide;

@end

@implementation RideOrDriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationUUIDKey"]);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onFindRideButtonPressed:(id)sender
{
    self.createRide = 1;
    [self performSegueWithIdentifier:@"resortsSegue" sender:sender];
}

- (IBAction)onCreateRideButtonPressed:(id)sender
{
    self.createRide = 2;
    [self performSegueWithIdentifier:@"resortsSegue" sender:sender];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"resortsSegue"])
    {
        UINavigationController *navigationController = [segue destinationViewController];
        RidesMainViewController *ridesMainViewController = [[navigationController viewControllers]objectAtIndex:0];
        ridesMainViewController.createRide = self.createRide;
    }
        else if ([segue.identifier isEqualToString:@"myHubSegue"])
    {
        //Nothing for now but you can use this if you need later
    }
}


@end
