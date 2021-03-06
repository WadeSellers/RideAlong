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
@property (weak, nonatomic) IBOutlet UIPickerView *feePicker;
@property (weak, nonatomic) IBOutlet UITextView *additionalTextView;
@property NSArray *feePickerArray;
@property NSArray *statePickerArray;
@property NSArray *availableSeatsPickerArray;

@end

@implementation CreateRideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"lalala: %@", self.resortObject);

    self.additionalTextView.delegate = self;

    self.availableSeatsPickerArray = @[@"Seats", @"1", @"2", @"3", @"4", @"5+"];
    self.availableSeatsPicker.delegate = self;
    self.availableSeatsPicker.dataSource = self;

    self.feePickerArray = @[@"Fee", @"$5", @"$10", @"$15", @"$20", @"$25", @"$30", @"$35", @"$40", @"$45", @"$50"];
    self.feePicker.delegate = self;
    self.feePicker.dataSource = self;

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
    ride[@"description"] = self.additionalTextView.text;
    ride[@"date"] = self.datePicker.date;
    ride[@"startName"] = self.startingMKPointAnnotation.subtitle;
    ride[@"endName"] = [self.resortObject objectForKey:@"name"];
    ride[@"driver"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationUUIDKey"];
    ride[@"comments"] = [[NSMutableArray alloc] init];

    [ride saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", [error userInfo]);
        }
    }];
}

@end
