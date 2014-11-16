//
//  CreateRideMapViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/8/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "CreateMapStartPointVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CreateRideDetailsVC.h"

@interface CreateMapStartPointVC () <MKMapViewDelegate, UISearchBarDelegate, UIAlertViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *mapSearchBar;
@property MKPointAnnotation *annotation;
@property MKPolygon* poly;
@end

@implementation CreateMapStartPointVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.poly = [[MKPolygon alloc]init];

    self.mapView.delegate = self;
    self.mapSearchBar.delegate =self;

    [self.mapView userTrackingMode];
    [self addSquareToMap];

    UINavigationController *navCon  = (UINavigationController*) [self.navigationController.viewControllers objectAtIndex:1];

    navCon.navigationItem.title = [self.resortObject objectForKey:@"name"];



    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:)name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)name:UIKeyboardDidHideNotification object:nil];


    //TODO
    //
    //    CLLocationCoordinate2D coord =  CLLocationCoordinate2DMake
    //    MKCoordinateRegion *region = MKCoordinateRegionMake(<#CLLocationCoordinate2D centerCoordinate#>, <#MKCoordinateSpan span#>)
    //      [self.mapView setRegion:
    //
    //      MKCoordinateRegionMake(newLocation, MKCoordinateSpanMake(5.0f, 5.0f)) animated:YES];
    //
}

- (void)keyboardDidShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    //UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - kbSize.height , self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)keyboardDidHide:(NSNotification *)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

    //UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + kbSize.height, self.view.frame.size.width, self.view.frame.size.height)];
}

#pragma mark - SearchBarDelegate Methods
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //Instantiate geolocation
    [self.mapSearchBar resignFirstResponder];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:self.mapSearchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {

        //Mark Location and Center
        CLPlacemark *placemark = [placemarks objectAtIndex:0];

        MKCoordinateRegion region;
        CLLocationCoordinate2D newLocation = [placemark.location coordinate];
        region.center = [(CLCircularRegion *)placemark.region center];

        //Drop a Pin

        if (self.annotation) {
            [self.annotation setCoordinate:newLocation];
            [self.annotation setTitle:@"Starting Point"];
            [self.annotation setSubtitle:self.mapSearchBar.text];
            [self.mapView addAnnotation:self.annotation];
            [self.mapView setRegion:MKCoordinateRegionMake(newLocation, MKCoordinateSpanMake(5.0f, 5.0f)) animated:YES];

        }
        else
        {
            self.annotation = [[MKPointAnnotation alloc] init];
            [self.annotation setCoordinate:newLocation];
            [self.annotation setTitle:@"Starting Point"];
            [self.annotation setSubtitle:self.mapSearchBar.text];
            [self.mapView addAnnotation:self.annotation];
            [self.mapView setRegion:MKCoordinateRegionMake(newLocation, MKCoordinateSpanMake(5.0f, 5.0f)) animated:YES];
        }
        
        [searchBar resignFirstResponder];
    }];
}

- (IBAction)mapNextButton:(id)sender
{
    if (self.annotation)
    {
        [self performSegueWithIdentifier:@"completeRideSegue" sender:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoopsie Daisy" message:@"Enter a starting address pretty please" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CreateRideDetailsVC *createRideViewController = [segue destinationViewController];
    createRideViewController.startingMKPointAnnotation = self.annotation;
    createRideViewController.resortObject = self.resortObject;
}

#pragma mark - MKMapViewDelegate Methods
//-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
//{
//    [self.mapView setRegion:MKCoordinateRegionMake(userLocation.coordinate, MKCoordinateSpanMake(0.0025f, 0.0025f)) animated:YES];
//}

//#pragma mark - Keyboard Methods
//- (void)registerForKeyboardNotifications
//{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                            selector:@selector(keyboardWasShown:)
//                                                name:UIKeyboardDidShowNotification object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                            selector:@selector(keyboardWillBeHidden:)
//                                                name:UIKeyboardWillHideNotification object:nil];
//
//}

- (void) addSquareToMap{

    CLLocationCoordinate2D  points[4];

    points[0] = CLLocationCoordinate2DMake(41.000512, -109.050116);
    points[1] = CLLocationCoordinate2DMake(41.002371, -102.052066);
    points[2] = CLLocationCoordinate2DMake(36.993076, -102.041981);
    points[3] = CLLocationCoordinate2DMake(36.99892, -109.045267);

    self.poly = [MKPolygon polygonWithCoordinates:points count:4];
    self.poly.title = @"Colorado";


    MKMapRect mapRect = [[MKPolygon polygonWithCoordinates:points count:4] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);

    region.center.latitude = points[0].latitude - (points[0].latitude - points[2].latitude) * 0.5;
    region.center.longitude = points[0].longitude + (points[2].longitude - points[0].longitude) * 0.5;
    region.span.latitudeDelta = fabs(points[0].latitude - points[3].latitude) * 4; // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(points[2].longitude - points[0].longitude) * 4; // Add a little extra space on the sides

    region = [self.mapView regionThatFits:region];
    [self.mapView setRegion:region animated:YES];

    [self.mapView addOverlay:self.poly];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{

    MKPolygonView* aView = [[MKPolygonView alloc] initWithPolygon:self.poly];

    aView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.15];
    aView.strokeColor = [[UIColor redColor] colorWithAlphaComponent:0.7];
    aView.lineWidth = 3;

    return aView;
}

//- (IBAction)allAction:(id)sender{
//    //CLLocationCoordinate2D SF = CLLocationCoordinate2DMake(37.786996, -122.440100) ;
//    CLLocation *center = [[CLLocation alloc] initWithLatitude:37.786996 longitude:-122.440100];
//    [self addSquareToMap:center withRadius:1000];
//}

@end
