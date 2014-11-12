//
//  ProfileViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/4/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "ProfileViewController.h"
#import "RideDetailsViewController.h"

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameTitle;
@property (weak, nonatomic) IBOutlet UITextView *userDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;

@end

@implementation ProfileViewController
- (IBAction)onBarButtonPressed:(id)sender {
    [self performSegueWithIdentifier:@"commentSegue" sender:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.identifier isEqualToString:@"commentsSegue"])
    {
        RideDetailsViewController *rideDetailsViewController = segue.destinationViewController;
        rideDetailsViewController.resortObject = self.resortObject;
    }

}


@end
