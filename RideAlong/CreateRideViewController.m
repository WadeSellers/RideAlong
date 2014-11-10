//
//  CreateRideViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/4/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "CreateRideViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface CreateRideViewController ()<UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate>
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *pinGesture;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIPickerView *availableSeatsPicker;
@property NSArray *availableSeatsPickerArray;

@property (weak, nonatomic) IBOutlet UIPickerView *feePicker;
@property NSArray *feePickerArray;

@property NSArray *statePickerArray;
@property (weak, nonatomic) IBOutlet UITextView *additionalTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@end

@implementation CreateRideViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.additionalTextView.delegate = self;

    [self.scroller setScrollEnabled:YES];
    [self.scroller setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    self.availableSeatsPickerArray = @[@"Seats", @"1", @"2", @"3", @"4", @"5+"];
    self.availableSeatsPicker.delegate = self;
    self.availableSeatsPicker.dataSource = self;

    self.feePickerArray = @[@"Fee", @"$5", @"$10", @"$15", @"$20", @"$25", @"$30", @"$35", @"$40", @"$45", @"$50"];
    self.feePicker.delegate = self;
    self.feePicker.dataSource = self;

}

#pragma mark - UITextView delegate method
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    self.additionalTextView.text = @"";
    [self.additionalTextView setTextAlignment:NSTextAlignmentLeft];
}

#pragma mark - Both Picker Delegate Methods
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView == self.availableSeatsPicker)
    {
        return self.availableSeatsPickerArray.count;
    }
    else
    {
        return self.feePickerArray.count;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView == self.availableSeatsPicker)
    {
        return self.availableSeatsPickerArray[row];
    }
    else
    {
        return self.feePickerArray[row];
    }}

#pragma mark - KeyboardDelegate Methods
- (void)keyboardDidShow:(NSNotification *)notification
{
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        [self.view setFrame:CGRectMake(0,-35,self.view.frame.size.width,self.view.frame.size.height - 220)];
    }
    else
    {
        [self.view setFrame:CGRectMake(0,-35,self.view.frame.size.width,self.view.frame.size.height - 220)];
    }
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    if ([[UIScreen mainScreen] bounds].size.height == 568)
    {
        [self.view setFrame:CGRectMake(0, 20, self.view.frame.size.width,self.view.frame.size.height + 220)];
    }
    else
    {
        [self.view setFrame:CGRectMake(0, 20, self.view.frame.size.width,self.view.frame.size.height + 220)];
    }
}

- (IBAction)onCreateRideButtonPressed:(id)sender
{
    PFObject *ride = [PFObject objectWithClassName:@"Ride"];
    PFGeoPoint *geoStartPoint = [[PFGeoPoint alloc] init];
    geoStartPoint.latitude = self.startingMKPointAnnotation.coordinate.latitude;
    geoStartPoint.longitude = self.startingMKPointAnnotation.coordinate.longitude;

    PFGeoPoint *georesortPoint = [[PFGeoPoint alloc] init];
    georesortPoint = [self.resortObject objectForKey:@"gpsLocation"];


    ride[@"geoStart"] = geoStartPoint;
    //ride[@"geoEnd"] = georesortPoint;
    ride[@"description"] = self.additionalTextView.text;
    ride[@"date"] = self.datePicker.date;
    ride[@"startName"] = self.startingMKPointAnnotation.subtitle;
    ride[@"endName"] = [self.resortObject objectForKey:@"name"];
    ride[@"driver"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationUUIDKey"];


    [ride saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", [error userInfo]);
        }
    }];
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
