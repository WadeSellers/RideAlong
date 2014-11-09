//
//  RideOrDriveViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/8/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RideOrDriveViewController.h"

@interface RideOrDriveViewController ()
@property NSNumber *indexSetter;

@end

@implementation RideOrDriveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onFindRideButtonPressed:(id)sender
{
    self.indexSetter = [NSNumber numberWithInt:0];
}

- (IBAction)onCreateRideButtonPressed:(id)sender
{
    self.indexSetter = [NSNumber numberWithInt:1]   ;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end
