//
//  RideDetailsViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/4/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RideDetailsViewController.h"
#import <Parse/Parse.h>

@interface RideDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextView *rideDetailsTextView;

@end

@implementation RideDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onBookLiftButtonPressed:(id)sender
{
    PFObject *ride = [PFObject objectWithClassName:@"Ride"];
    NSLog(@"date: %@", ride[@"Date"]);
    ride[@"Driver"] = [[PFUser currentUser] objectForKey:@"objectId"];
    NSLog(@"driver id: %@", ride[@"Driver"]);
    ride[@"Description"] = self.rideDetailsTextView;
    NSLog(@"description: %@", ride[@"Description"]);
    
}



@end
