//
//  RidesMainViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/5/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RidesMainViewController.h"
#import "RideOrDriveViewController.h"
#import "CreateRideMapViewController.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>

@interface RidesMainViewController ()<UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *resortsTableView;

@property MKMapItem *skiResortMapItem ;
@property CLLocationManager *locationManager;

@property NSArray *resorts;
@property (weak, nonatomic) IBOutlet UISegmentedControl *flowSegmentedControl;
@property NSString *resortNameSelected;

@end

@implementation RidesMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.flowSegmentedControl.selectedSegmentIndex = self.indexSetter;

    [[UINavigationBar appearance] setBarTintColor:[UIColor blackColor]];

    [self refreshDisplay];
}

-(void)viewWillAppear:(BOOL)animated
{

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
    if (self.flowSegmentedControl.selectedSegmentIndex == 0)
    {
        [self performSegueWithIdentifier:@"findAvailableRideSegue" sender:self];
    }
    else
    {
        [self performSegueWithIdentifier:@"createNewRideSegue" sender:self];
    }
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
    if ([segue.identifier isEqualToString:@"createNewRideSegue"])
    {
    CreateRideMapViewController *createRideMapViewController = [segue destinationViewController];
    NSIndexPath *indexPath = [self.resortsTableView indexPathForSelectedRow];
    PFObject *resort = [self.resorts objectAtIndex:indexPath.row];
    createRideMapViewController.resortObject = resort;
    }
    else
    {
    //THIS IS A GREAT PICKUP POINT
    }
}











/*
-(void) addSkiResortLocation{
    CLGeocoder *geocoder =[[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:@"colorado ski resorts" completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark *placemark in placemarks) {
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc]init];
            annotation.coordinate =placemark.location.coordinate;
            [self.ridesMapView addAnnotation:annotation];
//            [self findSkiLift:placemark.location];
        }

    }];
}
*/
//- (void) findSkiLift
////:(CLLocation *)location
//{
//    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
//    request.naturalLanguageQuery =@"Colorado Ski Resort";
////    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1, 1));
//    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
//    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
//
////        Resort *resort = [[Resort alloc]init];
//        self.skiResorts = response.mapItems;
//        for (MKMapItem *mapItem in self.skiResorts)
//        {
//            MKPointAnnotation *skiResortAnnotation = [[MKPointAnnotation alloc] init];
//            skiResortAnnotation.coordinate = mapItem.placemark.location.coordinate;
//            skiResortAnnotation.title = mapItem.placemark.name;
//            [self.ridesMapView addAnnotation:skiResortAnnotation];
////            [self.ridesMapView addAnnotations:self.skiResorts];
//
//            Resort *resort = [[Resort alloc]init];
//
//            resort.name =mapItem.name;
//
////            resort.name = skiResortAnnotation.title;
//
//            [self.resortsNames addObject:resort];
////            NSLog(@"resorts %@", mapItem.placemark.location.coordinate);
//             [self.ridesMapView addAnnotation:skiResortAnnotation];
//
////            NSLog(@" %@",mapItem.name);
//            [self.ridesTableView reloadData];



//
//            CLLocationCoordinate2D center = skiResortAnnotation.coordinate;
//
//            MKCoordinateSpan span;
//            span.latitudeDelta = 5;
//            span.longitudeDelta = 5;
//
//            MKCoordinateRegion region;
//            region.center = center;
//            region.span = span;
//            
//            [self.ridesMapView setRegion:region animated:YES];




//            MKMapPoint annotationPoint = MKMapPointForCoordinate(self.ridesMapView.userLocation.coordinate);
//            MKMapRect zoomRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
//            //MKMapRect zoomRect = MKMapRectNull;
//            for (id <MKAnnotation> annotation in self.ridesMapView.annotations)
//            {
//                MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
//                MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
//                zoomRect = MKMapRectUnion(zoomRect, pointRect);
//            }
//            [self.ridesMapView setVisibleMapRect:zoomRect animated:YES];
//        }

//        self.skiResortMapItem = self.skiResorts.firstObject;

//        self.myTextView.text =[NSString stringWithFormat:@" %@", mapItem.name];
//    }];
//}
//
//
//-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//
//    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MyPinID"];
//    pin.canShowCallout = YES;
//    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    pin.image = [UIImage imageNamed:@"Flag"];
//    return pin;
//}
//
//-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
//    CLLocationCoordinate2D center = view.annotation.coordinate;
//
//    MKCoordinateSpan span;
//    span.latitudeDelta = 0.05;
//    span.longitudeDelta = 0.05;
//
//    MKCoordinateRegion region;
//    region.center = center;
//    region.span = span;
//
//    [self.ridesMapView setRegion:region animated:YES];
//    
//}


@end
