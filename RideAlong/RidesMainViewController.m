//
//  RidesMainViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/5/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RidesMainViewController.h"
#import "RideOrDriveViewController.h"
#import "RideMapViewController.h"
#import "CreateRideMapViewController.h"
#import "ProfileViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface RidesMainViewController ()<UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *resortsTableView;

@property MKMapItem *skiResortMapItem ;
@property CLLocationManager *locationManager;

@property NSArray *resorts;

@property NSString *resortNameSelected;

@end

@implementation RidesMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self refreshDisplay];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];

    [self refreshDisplay];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resorts.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    PFObject *resort = [self.resorts objectAtIndex:indexPath.row];
    cell.textLabel.text = resort[@"name"];

    PFFile *resortImage = resort[@"logo"];
    [resortImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            cell.imageView.image = image;
        }
    }];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"createNewRideSegue" sender:self];
}

- (void)refreshDisplay
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
            [self.resortsTableView reloadData];
        }
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [self.resortsTableView indexPathForSelectedRow];
    PFObject *resort = [self.resorts objectAtIndex:indexPath.row];

    if ([segue.identifier isEqualToString:@"createNewRideSegue"])
    {
        CreateRideMapViewController *createRideMapViewController = [segue destinationViewController];
        createRideMapViewController.resortObject = resort;
    }
}


@end
