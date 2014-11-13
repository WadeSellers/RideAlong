//
//  ProfileViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/4/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "ProfileViewController.h"
#import "RideDetailsViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *myRidesTableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;
@property NSArray *driverArray;
@property NSArray *passengerArray;
@end


@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self retrieveUserRides];

}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - TableViewDelegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Spock, you have the con...";
    }
    else
    {
        return @"Are we there yet? Are we there yet?";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [self.driverArray count];
    }
    else if (section == 1)
    {
        return [self.passengerArray count];
    }
    else
    {
        return 1;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];

    if (indexPath.section == 0) {
        PFObject *driverRide = [self.driverArray objectAtIndex:indexPath.row];
        cell.textLabel.text = driverRide[@"endName"];
    }
    else
    {
        PFObject *passengerRide = [self.passengerArray objectAtIndex:indexPath.row];
        cell.textLabel.text = passengerRide[@"endName"];
    }
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [self performSegueWithIdentifier:@"rideDetailSegue" sender:self];
//}

#pragma mark - Parse Retrieval Methods
- (void)retrieveUserRides
{
    PFQuery *userIsDriverQuery = [PFQuery queryWithClassName:@"Ride"];
    [userIsDriverQuery whereKey:@"driver" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationUUIDKey"]];
    [userIsDriverQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error.userInfo);
            self.driverArray = [NSArray array];
        }
        else
        {
            self.driverArray = objects;
            //NSLog(@"rides: %@", self.driverArray);
        }
        PFQuery *userIsPassengerQuery = [PFQuery queryWithClassName:@"Ride"];
        [userIsPassengerQuery whereKey:@"passenger" equalTo:[[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationUUIDKey"]];
        [userIsPassengerQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error)
            {
                NSLog(@"Error: %@", error.userInfo);
                self.passengerArray = [NSArray array];
            }
            else
            {
                self.passengerArray = objects;
//                NSLog(@"rides: %@", self.passengerArray);
            }
//            NSLog(@"Driver: %@", self.driverArray);
//            NSLog(@"Passenger: %@", self.passengerArray);
            [self.myRidesTableView reloadData];
        }];
    }];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"rideDetailSegue"])
    {
        RideDetailsViewController *rideDetailsViewController = [segue destinationViewController];
        PFObject *resortObjectToPass;
    
        if ([self.myRidesTableView indexPathForSelectedRow].section == 0)
        {
            resortObjectToPass = [self.driverArray objectAtIndex:[self.myRidesTableView indexPathForSelectedRow].row];
            NSLog(@"%@", resortObjectToPass);
        }
        else
        {
        resortObjectToPass = [self.passengerArray objectAtIndex:[self.myRidesTableView indexPathForSelectedRow].row];
        NSLog(@"%@", resortObjectToPass);

        }
        rideDetailsViewController.resortObject = resortObjectToPass;
    }
}


@end
