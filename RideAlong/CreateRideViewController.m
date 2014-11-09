//
//  CreateRideViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/4/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "CreateRideViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <Parse/Parse.h>

@interface CreateRideViewController ()<CLLocationManagerDelegate, MKAnnotation, UIGestureRecognizerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) CLLocationManager *locationManager;
@property MKPointAnnotation *dropPin;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *pinGesture;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
//@property CLLocationCoordinate2D coordinate;
//@property NSString * title;
//@property NSString * subtitle;

@property (weak, nonatomic) IBOutlet UIPickerView *availableSeatsPicker;
@property NSArray *availableSeatsPickerArray;

@property (weak, nonatomic) IBOutlet UIPickerView *feePicker;
@property NSArray *feePickerArray;

@property (weak, nonatomic) IBOutlet UIPickerView *statePicker;
@property NSArray *statePickerArray;

@end

@implementation CreateRideViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
    {
        [self.locationManager requestWhenInUseAuthorization];
    }

    self.availableSeatsPickerArray = @[@"Available Seats", @"1", @"2", @"3", @"4", @"5+"];
    self.availableSeatsPicker.delegate = self;
    self.availableSeatsPicker.dataSource = self;

    self.feePickerArray = @[@"$5", @"$10", @"$15", @"$20", @"$25", @"$30", @"$35", @"$40", @"$45", @"$50"];
    self.feePicker.delegate = self;
    self.feePicker.dataSource = self;

    self.statePickerArray = @[@"AL", @"AK", @"AZ", @"AR", @"CA", @"CO", @"CT", @"DE", @"FL", @"GA", @"HI", @"ID", @"IL", @"IN", @"IA", @"KS", @"KY", @"LA", @"ME", @"MD", @"MA", @"MI", @"MN", @"MS", @"MO", @"MT", @"NE", @"NV", @"NH", @"NJ", @"NM", @"NY", @"NC", @"ND", @"OH", @"OK", @"OR", @"PA", @"RI", @"SC", @"SD", @"TN", @"TX", @"UT", @"VT", @"VA", @"WA", @"WV", @"WI", @"WY"];
    [self.statePicker selectRow:6 inComponent:0 animated:NO];


}

#pragma mark - Both Picker Delegate Methods
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.availableSeatsPickerArray.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.availableSeatsPickerArray[row];
}

- (void)pinDrop{
    CLLocationCoordinate2D coord;

    self.dropPin =[[MKPointAnnotation alloc]init];
    self.dropPin.coordinate = coord;
    self.dropPin.title =@"PostARide";
    [self.mapView addAnnotation:self.dropPin];

    UITapGestureRecognizer *pinGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pinGesture:)];
    pinGesture.delegate = self;
    [self.mapView addGestureRecognizer:pinGesture];
}
- (IBAction)pinGesture:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self.mapView];
    CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
    // Then all you have to do is create the annotation and add it to the map

    self.dropPin = [[MKPointAnnotation alloc] init];
    self.dropPin.coordinate = locCoord;
    [self.mapView addAnnotation:self.dropPin];

}



//
////    [longPressGesture release];
//}
//
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
//    return true;
//}
//
//
//// Location Manager Delegate Methods
//- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
//{
//    NSLog(@"%@", [locations lastObject]);
//}
//
//-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
//
//    self.dropPin = annotation;
//
//    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:self.dropPin reuseIdentifier:@"MyPinID"];
//    pin.canShowCallout = YES;
//    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    pin.image = [UIImage imageNamed:@"Flag"];
//    pin.annotation = self.dropPin;
//    pin.animatesDrop = YES;
//    pin.calloutOffset = CGPointMake(-5, 5);
//    pin.animatesDrop = YES;
//
//    return pin;
//}
//
//-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
//    CLLocationCoordinate2D center = view.annotation.coordinate;
//
//    MKCoordinateSpan span;
//    span.latitudeDelta = 0.01;
//    span.longitudeDelta = 0.01;
//
//    MKCoordinateRegion region;
//    region.center = center;
//    region.span = span;
//
//    [self.mapView setRegion:region animated:YES];
//    
//}
//
//-(void)pinGesture:(UIGestureRecognizer*)sender {
//    if (sender.state == UIGestureRecognizerStateBegan)
//    {
//        [self.mapView removeGestureRecognizer:sender];
//    }
//    else
//    {
//        // Here we get the CGPoint for the touch and convert it to latitude and longitude coordinates to display on the map
//        CGPoint point = [sender locationInView:self.mapView];
//        CLLocationCoordinate2D locCoord = [self.mapView convertPoint:point toCoordinateFromView:self.mapView];
//        // Then all you have to do is create the annotation and add it to the map
//
//        self.dropPin = [[MKPointAnnotation alloc] init];
//        self.dropPin.coordinate = locCoord;
//        [self.mapView addAnnotation:self.dropPin];
////        [self.dropPin release];
//    }
//}

//- (IBAction)onCompleteRideButtonPressed:(id)sender
//{
//    PFObject *ride = [PFObject objectWithClassName:@"Ride"];
//
//    [ride saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (error)
//        {
//            NSLog(@"Error: %@", [error userInfo]);
//        }
//        else
//        {
//
//        }
//    }];
//
//}


@end
