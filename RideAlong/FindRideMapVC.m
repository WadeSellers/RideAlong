//
//  RideMapViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/5/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "FindRideMapVC.h"
#import "FindRideDetailsVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MyCustomPin.h"

@interface FindRideMapVC () <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *rideMapView;
@property (weak, nonatomic) IBOutlet UITableView *resortsTableView;
@property CLLocationManager *locationManager;
@property MKPointAnnotation *myPin;
@property NSArray *rides;
@property PFObject *resortObject;
@property NSMutableArray *annotationsArray;
@property NSArray *resorts;
@property UITableViewCell *myCell;
@end

@implementation FindRideMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.annotationsArray = [NSMutableArray array];
    self.rideMapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.resorts = [[NSArray alloc] init];

    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }

    [self.locationManager startUpdatingLocation];

    self.myPin = [[MKPointAnnotation alloc] init];

    self.myPin.title = @"YAY";
    [self.rideMapView addAnnotation:self.myPin];

    self.rideMapView.delegate = self;




}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self refreshDisplay];

}


- (void)refreshDisplay
{
    PFQuery *rideQuery = [PFQuery queryWithClassName:@"Ride"];
    //[query whereKey:@"endName" equalTo:self.resortObject[@"name"]];
    [rideQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error.userInfo);
            self.rides = [NSArray array];
        }
        else
        {
            self.rides = objects;
            [self makeAndPlaceRidePins];
        }
        PFQuery *resortQuery = [PFQuery queryWithClassName:@"Resort"];
        [resortQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error)
            {
                NSLog(@"Error: %@", error.userInfo);
            }
            else
            {
                self.resorts = [[NSArray alloc] initWithArray:objects];
//The issue with the thumbnails not loading nicely may be here too.  Perhaps I should be doing the reloadData methods elsewhere instead of in this nested block
                
                [self.resortsTableView reloadData];
            }
        }];
    }];

}

#pragma mark - MapView Methods

- (void)makeAndPlaceRidePins
{
    for (PFObject *ride in self.rides)
    {
        PFGeoPoint *tempGeoPoint = [ride objectForKey:@"geoStart"];

        CLLocationCoordinate2D annotationCoordinate = CLLocationCoordinate2DMake(tempGeoPoint.latitude, tempGeoPoint.longitude);

        MyMKPointAnnotation *annotation= [[MyMKPointAnnotation alloc] init];
        annotation.coordinate = annotationCoordinate;
        annotation.title = ride[@"startName"];
        annotation.rideObject = ride;

        //This may be where the issue of the zoom is coming from, but I am not sure exactly how to remedy the situation.

        [self.annotationsArray addObject:annotation];
        [self.rideMapView setRegion:MKCoordinateRegionMake(annotationCoordinate, MKCoordinateSpanMake(5.0f, 5.0f)) animated:YES];
    }
    [self.rideMapView showAnnotations:self.annotationsArray animated:YES];
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MyCustomPin *pin = [[MyCustomPin alloc] initWithAnnotation:annotation reuseIdentifier:@"MyPinId"];
    pin.enabled = YES;
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.myPointAnnotation = annotation;

    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
     [self performSegueWithIdentifier:@"rideDetailsSegue" sender:view];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(MyCustomPin *)sender
{
    FindRideDetailsVC *rideDetailsViewController = [segue destinationViewController];
    rideDetailsViewController.tappedAnnotation = sender;
}

#pragma mark - TableView Delegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resorts.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.myCell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    PFObject *resort = [self.resorts objectAtIndex:indexPath.row];
    self.myCell.textLabel.text = resort[@"name"];
    UIImage *placeholderImage = [UIImage imageNamed:@"mountain"];
    self.myCell.imageView.image = placeholderImage;
    [self.myCell setNeedsLayout];


    PFFile *resortImage = resort[@"logo"];
    [resortImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error);
        }
        else
        {
            UIImage *image = [UIImage imageWithData:imageData];
            self.myCell.imageView.image = image;
        }
    }];
    return self.myCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFQuery *rideQuery = [PFQuery queryWithClassName:@"Ride"];
    PFObject *selectedObject = [self.resorts objectAtIndex:indexPath.row];
    [rideQuery whereKey:@"endName" containsString:selectedObject[@"name"]];
    [rideQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error.userInfo);
            self.rides = [NSArray array];
        }
        else
        {
            self.rides = objects;
            [self makeAndPlaceRidePins];
        }
    }];
    self.title = selectedObject[@"name"];
}



@end
