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
#import "CustomResortTableViewCell.h"
#import "FindRideCollectionViewCell.h"

@interface FindRideMapVC () <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *rideMapView;
@property (weak, nonatomic) IBOutlet UITableView *resortsTableView;
@property CLLocationManager *locationManager;
@property MKPointAnnotation *myPin;
@property NSArray *rides;
@property PFObject *resortObject;
@property NSMutableArray *annotationsArray;
@property UITableViewCell *myCell;
@property (weak, nonatomic) IBOutlet UIButton *todayButton;
@property (weak, nonatomic) IBOutlet UIButton *tomorrowButton;
@property (weak, nonatomic) IBOutlet UIButton *weekButton;
@property NSDate *startDate;
@property NSDate *endDate;
@property PFObject *resortSelected;
@property BOOL resortWasSelected;

@end

@implementation FindRideMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.rideMapView.delegate = self;

    self.annotationsArray = [NSMutableArray array];
    self.resorts = [[NSArray alloc] init];

    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }

    [self.locationManager startUpdatingLocation];
    [self.rideMapView showsUserLocation];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.startDate = [self takeTimeOutOfDates:[NSDate date]];
    self.resortWasSelected = NO;

    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 7;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *revisedendDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
    self.endDate = [self takeTimeOutOfDates:revisedendDate];

    [self.weekButton setSelected:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self parseForResults];
    [self.resortsTableView reloadData];
    [self removeAllAnnotations];


}



- (void)parseForResults
{
    PFQuery *rideQuery = [PFQuery queryWithClassName:@"Ride"];
    [rideQuery whereKey:@"date" greaterThan:self.startDate];
    [rideQuery whereKey:@"date" lessThan:self.endDate];
    if (self.resortWasSelected == YES)
    {
        [rideQuery whereKey:@"endName" containsString:self.resortSelected[@"name"]];
    }
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
                [self.resortsTableView reloadData];
            }
        }];
    }];

}

#pragma mark - MapView Methods


-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //check annotation is not user location
    if([annotation isEqual:[self.rideMapView userLocation]])
    {
        //bail
        return nil;
    }

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
    CustomResortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    PFObject *resort = [self.resorts objectAtIndex:indexPath.row];
    [cell pullResortImage:resort];
    cell.textLabel.text = resort[@"name"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.rideMapView removeAnnotations:self.rideMapView.annotations];
    self.resortSelected = [self.resorts objectAtIndex:indexPath.row];
    self.resortWasSelected = YES;

    [self parseForResults];
//    PFQuery *rideQuery = [PFQuery queryWithClassName:@"Ride"];
//    PFObject *selectedObject = [self.resorts objectAtIndex:indexPath.row];
//    [rideQuery whereKey:@"endName" containsString:selectedObject[@"name"]];
//    [rideQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
//        if (error)
//        {
//            NSLog(@"Error: %@", error.userInfo);
//            self.rides = [NSArray array];
//        }
//        else
//        {
//            self.rides = objects;
//            [self makeAndPlaceRidePins];
//        }
//    }];
//    [self makeAndPlaceRidePins];
    self.title = self.resortSelected[@"name"];
}

- (void)makeAndPlaceRidePins
{
    [self.annotationsArray removeAllObjects];
    for (PFObject *ride in self.rides)
    {
        PFGeoPoint *tempGeoPoint = [ride objectForKey:@"geoStart"];
        CLLocationCoordinate2D annotationCoordinate = CLLocationCoordinate2DMake(tempGeoPoint.latitude, tempGeoPoint.longitude);
        MyMKPointAnnotation *annotation= [[MyMKPointAnnotation alloc] init];
        annotation.rideObject = ride;
        annotation.coordinate = annotationCoordinate;
        annotation.title = ride[@"startName"];
        [self.annotationsArray addObject:annotation];

        //This sets zoom on pics for when a resort is tapped
        [self.rideMapView setRegion:MKCoordinateRegionMake(annotationCoordinate, MKCoordinateSpanMake(0.005f, 0.005f)) animated:YES];
    }
    [self.rideMapView showAnnotations:self.annotationsArray animated:YES];
}

-(void)removeAllAnnotations
{
    //Get the current user location annotation.
    id userAnnotation=self.rideMapView.userLocation;

    //Remove all added annotations
    [self.rideMapView removeAnnotations:self.rideMapView.annotations];

    // Add the current user location annotation again.
    if(userAnnotation!=nil)
        [self.rideMapView addAnnotation:userAnnotation];
}
- (IBAction)dateButtonTapped:(id)sender
{
    [self.todayButton setSelected:NO];
    [self.tomorrowButton setSelected:NO];
    [self.weekButton setSelected:NO];

    if ([[sender currentTitle] isEqualToString:@"All Day Long"])
    {
        [self.todayButton setSelected:YES];

        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 0;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *revisedStartDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
        self.startDate = [self takeTimeOutOfDates:revisedStartDate];
        dayComponent.day = 1;
        NSDate *revisedEndDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
        self.endDate = [self takeTimeOutOfDates:revisedEndDate];
    }
    else if ([[sender currentTitle] isEqualToString:@"Tomorrow"])
    {
        [self.tomorrowButton setSelected:YES];

        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 1;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *revisedStartDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
        self.startDate = [self takeTimeOutOfDates:revisedStartDate];
        dayComponent.day = 2;
        NSDate *revisedEndDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
        self.endDate = [self takeTimeOutOfDates:revisedEndDate];
    }
    else //button pressed must be "One Week Out"
    {
        [self.weekButton setSelected:YES];

        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 0;
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDate *revisedStartDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
        self.startDate = [self takeTimeOutOfDates:revisedStartDate];
        dayComponent.day = 7;
        NSDate *revisedEndDate = [calendar dateByAddingComponents:dayComponent toDate:[NSDate date] options:0];
        self.endDate = [self takeTimeOutOfDates:revisedEndDate];
    }
}

- (NSDate *)takeTimeOutOfDates: (NSDate *)inputDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitYear) fromDate:inputDate];
    NSDate *reformattedDate = [calendar dateFromComponents:components];

    NSLog(@"Now todays date starts at midnight: %@", inputDate);
    return reformattedDate;
}



@end

