//
//  ProfileViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/4/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "ProfileViewController.h"
#import "RideDetailsViewController.h"

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
    else{
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
        PFObject *ride = [self.driverArray objectAtIndex:indexPath.row];
        cell.textLabel.text = ride[@"endName"];
    }
    else
    {
        PFObject *ride = [self.passengerArray objectAtIndex:indexPath.row];
        cell.textLabel.text = ride[@"endName"];
    }
    return cell;
}

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
    }];

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
            //NSLog(@"rides: %@", self.passengerArray);
        }
        [self.myRidesTableView reloadData];
        NSLog(@"driver array: %@", self.driverArray);
        NSLog(@"passenger array: %@", self.passengerArray);

    }];
}



- (IBAction)onBarButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"commentSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"commentsSegue"])
    {
        RideDetailsViewController *rideDetailsViewController = segue.destinationViewController;
        rideDetailsViewController.resortObject = self.resortObject;
    }
}





@end
