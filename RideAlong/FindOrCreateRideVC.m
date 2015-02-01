//
//  RideOrDriveViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/8/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "FindOrCreateRideVC.h"
#import "FindRideDetailsVC.h"
#import "FindRideMapVC.h"
#import "MyCustomPin.h"
#import "CreateChooseResortVC.h"
#import "UIButton+PrimaryButton.h"

@interface FindOrCreateRideVC ()
@property MyCustomPin *ridePin;
@property NSArray *resorts;
@property NSArray *resortImages;

@property (weak, nonatomic) IBOutlet UIImageView *mountainLogo;
@property (weak, nonatomic) IBOutlet UILabel *skiLiftLabel;
@property (weak, nonatomic) IBOutlet UILabel *sloganLabel;
@property (weak, nonatomic) IBOutlet UIButton *findRideButton;
@property (weak, nonatomic) IBOutlet UIButton *createNewRide;
@property (weak, nonatomic) IBOutlet UIButton *myRideButton;


@end

@implementation FindOrCreateRideVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.resortImages = [[NSArray alloc] init];
    [self pullInResorts];

    [self introAnimations];

}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];


}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [self introduction];
//}

- (void)passengerSetupAndSave
{
    self.ridePin.myPointAnnotation.rideObject[@"passenger"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationUUIDKey"];

    [self.ridePin.myPointAnnotation.rideObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", [error userInfo]);
        }
    }];
}

- (void)pullInResorts
{
    PFQuery *query = [PFQuery queryWithClassName:@"Resort"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error.userInfo);
        }
        else
        {
            self.resorts = [[NSArray alloc] initWithArray:objects];
        }
    }];
}

- (IBAction)unwindFromCompleteNewRide:(UIStoryboardSegue *)segue
{

}

- (IBAction)unwindFromBookLift:(UIStoryboardSegue *)segue
{
    FindRideDetailsVC *rideDetailsViewController = [segue sourceViewController];
    self.ridePin = rideDetailsViewController.tappedAnnotation;
    [self passengerSetupAndSave];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"findRideSegue"])
    {
        FindRideMapVC *findRideMapVC = [segue destinationViewController];
        findRideMapVC.resorts = self.resorts;
    }

}

- (void)introAnimations
{
    [self.findRideButton setupButton:@"Find A Ride" setEnabled:YES setVisible:NO];
    [self.createNewRide setupButton:@"Create New Ride" setEnabled:YES setVisible:NO];
    [self.myRideButton setupButton:@"My Rides" setEnabled:YES setVisible:NO];

    self.mountainLogo.alpha = 0;
    self.skiLiftLabel.alpha = 0;
    self.sloganLabel.alpha = 0;

    [UIView animateWithDuration:1.0 delay:.25 options:UIViewAnimationOptionCurveEaseIn animations:^
    {
        self.mountainLogo.alpha = 0.4;
    } completion:^(BOOL finished)
    {
        if (finished)
        {
            [UIView animateWithDuration:1.0
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseIn
                             animations:^
            {
                self.skiLiftLabel.alpha = 1;
            } completion:^(BOOL finished)
            {
                if (finished)
                {
                    [UIView animateWithDuration:1.0 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
                    {
                        [self.findRideButton fadeInWithDuration:0.25 delay:0.0];
                        [self.createNewRide fadeInWithDuration:0.25 delay:0.25];
                        [self.myRideButton fadeInWithDuration:0.25 delay:0.50];
                    } completion:^(BOOL finished)
                    {
                        if (finished)
                        {
                            [UIView animateWithDuration:1.0
                                                  delay:1.25
                                                options:UIViewAnimationOptionCurveEaseIn
                                             animations:^
                            {
                                self.sloganLabel.alpha = 1;
                            }
                                             completion:nil];
                        }
                    }];
                }
            }];
        }
    }];

}

























@end
