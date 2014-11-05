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
@property (weak, nonatomic) IBOutlet UIDatePicker *rideDatePicker;
@property (weak, nonatomic) IBOutlet UITextField *startLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *endLocationTextField;
@property (weak, nonatomic) IBOutlet UITextField *availableSeatsTextField;
@property (weak, nonatomic) IBOutlet UITextField *donationTextField;
@property (weak, nonatomic) IBOutlet UITextView *rideDetailsTextView;

@end

@implementation RideDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)onSaveButtonPressed:(id)sender
{

}



@end
