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

@interface FindOrCreateRideVC ()
@property MyCustomPin *ridePin;
@property NSArray *resorts;
@property NSArray *resortImages;

@property (weak, nonatomic) IBOutlet UIImageView *mountainLogo;
@property (weak, nonatomic) IBOutlet UILabel *skiLiftLabel;
@property (weak, nonatomic) IBOutlet UILabel *sloganLabel;


@end

@implementation FindOrCreateRideVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.resortImages = [[NSArray alloc] init];
    [self pullInResorts];

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

//- (void)introduction
//{
//
//    [UIView transitionWithView:self.mountainLogo duration:0.5 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
//        self.mountainLogo.image = [UIImage imageNamed:@"snowboarder"];
//    } completion:^(BOOL finished) {
//        nil;
//    }];
//
//
//}

@end
