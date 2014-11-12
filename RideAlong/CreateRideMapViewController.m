//
//  CreateRideMapViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/8/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "CreateRideMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CreateRideViewController.h"

@interface CreateRideMapViewController () <MKMapViewDelegate, UISearchBarDelegate, UIAlertViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISearchBar *mapSearchBar;
@property MKPointAnnotation *annotation;
@end

@implementation CreateRideMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.mapView.delegate = self;
    self.mapSearchBar.delegate =self;

    [self.mapView userTrackingMode];

    UINavigationController *navCon  = (UINavigationController*) [self.navigationController.viewControllers objectAtIndex:1];

    navCon.navigationItem.title = [self.resortObject objectForKey:@"name"];



    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)keyboardDidShow:(NSNotification*)aNotification
{
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
            [self.mapView setRegion:MKCoordinateRegionMake(newLocation, MKCoordinateSpanMake(0.0025f, 0.0025f)) animated:YES];
        }
        else
        {
            self.annotation = [[MKPointAnnotation alloc] init];
            [self.annotation setCoordinate:newLocation];
            [self.annotation setTitle:@"Starting Point"];
            [self.annotation setSubtitle:self.mapSearchBar.text];
            [self.mapView addAnnotation:self.annotation];
            [self.mapView setRegion:MKCoordinateRegionMake(newLocation, MKCoordinateSpanMake(0.0025f, 0.0025f)) animated:YES];
        }

        [searchBar resignFirstResponder];
    }];
}

- (IBAction)mapNextButton:(id)sender
{
    if (self.annotation)
    {
        [self performSegueWithIdentifier:@"setupRideSegue" sender:self];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoopsie Daisy" message:@"Enter a starting address pretty please" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CreateRideViewController *createRideViewController = [segue destinationViewController];
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
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
//    
//}


@end
