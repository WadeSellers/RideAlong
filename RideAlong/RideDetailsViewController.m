//
//  RideDetailsViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/4/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RideDetailsViewController.h"

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
