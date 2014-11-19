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

@interface FindRideMapVC () <MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *rideMapView;
@property (weak, nonatomic) IBOutlet UITableView *resortsTableView;
@property CLLocationManager *locationManager;
@property MKPointAnnotation *myPin;
@property NSArray *rides;
@property PFObject *resortObject;
@property NSMutableArray *annotationsArray;
@property UITableViewCell *myCell;
@property NSArray *datesArray;
@property (weak, nonatomic) IBOutlet UIDatePicker *findRideDatePicker;
@property (weak, nonatomic) IBOutlet UICollectionView *findRidesCollectionView;
@property NSMutableArray *days;
@property NSMutableArray *daysOfWeek;
@end

@implementation FindRideMapVC

- (void)viewDidLoad {
    [super viewDidLoad];

    //populate array with dates
//    [self setDates];
    [self getDate];

    self.daysOfWeek = [NSMutableArray array];
    self.days = [NSMutableArray new];
      [self setDates];
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

    self.datesArray = [[NSArray alloc]init];

    [self.findRidesCollectionView setDelegate:self];

//        self.findRideDatePicker = [[UIDatePicker alloc]init];

    // Set the delegate

    // Add the picker in our view.
//    [self.view addSubview: self.findRideDatePicker];






//    NSDate *ridedDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"FindRideMapVC.selectedDate"];
//    [self.findRideDatePicker setDate:ridedDate animated:YES];



//    [self.findRideDatePicker setDate:ridedDate animated:NO];

//    NSLog(@"today is %@", ridedDate);
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self refreshDisplay];
    [self.resortsTableView reloadData];

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
    CustomResortTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    PFObject *resort = [self.resorts objectAtIndex:indexPath.row];
    [cell pullResortImage:resort];


    //NSLog(@"resorts: %@", resort);
    cell.textLabel.text = resort[@"name"];
    //UIImage *resortImage = [resort objectForKey:@"logo"];
    //cell.imageView.image = resortImage;
    //[cell setNeedsLayout];


//    PFFile *resortImage = resort[@"logo"];
//    [resortImage getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//        if (error)
//        {
//            NSLog(@"%@", error);
//        }
//        else
//        {
//            UIImage *image = [UIImage imageWithData:imageData];
//            cell.imageView.image = image;
//        }
//    }];
    return cell;
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
#pragma mark - CollectionView Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 7;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";

    FindRideCollectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:identifier
                                              forIndexPath:indexPath];

 
    cell.backgroundColor = [UIColor grayColor];

//    [cell.findRideButton setTitle:[self.days objectAtIndex:indexPath] forState:UIControlStateNormal];
    [cell.findRideButton setTitle:[self.days objectAtIndex:indexPath.row] forState:UIControlStateNormal];


    cell.tintColor = [UIColor redColor];
//    cell.textLabel.text = @"Hello";


//    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:100];
//    recipeImageView.image = [imageArray objectAtIndex:
//                             (indexPath.section * noOfSection + indexPath.row)];

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
    {
        NSLog(@"didselect");
        NSLog(@"yaya %@", indexPath);
    }


- (IBAction)findRidesForDateFromDatePicker:(id)sender {
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    CGAffineTransform rotate = CGAffineTransformMakeRotation(3.14/2);
    rotate = CGAffineTransformScale(rotate, 1, 3);
    [self.findRideDatePicker setTransform:rotate];

    NSDate *selectedDate = [self.findRideDatePicker date];
//
//    [defaults setObject:selectedDate forKey:@"FindRideMapVC.selectedDate"];
//    NSDate* eventDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"FindRideMapVC.selectedDate"];

    NSLog(@"and th date is %@", selectedDate);
    NSLog(@"and thee date is %@", self.findRideDatePicker.date);

}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
return 31;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 1;
}

#pragma mark - Date Methods
-(NSString *)getDate {

    NSString *dateString = @"Thu Oct 25 10:34:58 +0000 2012";


    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MMM-dd";
//    [dateFormatter setDateFormat:@"dd/MM/yyyy hh:mm"];
    NSDate *date = [dateFormatter dateFromString:dateString];
//Null
    NSLog(@"hello, date is %@", date);
//date is 2013-01-24 16:45:32
    NSLog(@"hi, the date is %@", [dateFormatter stringFromDate:[NSDate date]]);


    //dateFromString
    NSString *currentDateString = @"2013-03-24 10:45:32";
    NSDateFormatter *dateFormater = [[NSDateFormatter alloc] init];
    [dateFormater setDateFormat:@"yyyy-MM-DD HH:mm:ss"];
//    [dateFormater setDateFormat:@"MM-DD"];

    NSDate *currentDate = [dateFormater dateFromString:currentDateString];
      NSLog(@"hello hello, date is %@", currentDate);
    NSLog(@"sup?");

    //stringFromDate
    NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0
                                                              locale:[NSLocale currentLocale]];
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:formatString];

    NSString *todayString = [myDateFormatter stringFromDate:[NSDate date]];
    // Nov-18
    NSLog(@"todayString: %@", todayString);

//    CFAbsoluteTime at = CFAbsoluteTimeGetCurrent();
//    CFTimeZoneRef tz = CFTimeZoneCopySystem();
//    SInt32 WeekdayNumber = CFAbsoluteTimeGetDayOfWeek(at, tz);
//
//    NSLog(@"day of the week is %@", WeekdayNumber);

    NSDateFormatter *dateFormatterWeek = [[NSDateFormatter alloc] init];
    [dateFormatterWeek setDateFormat:@"EEEE"];
    NSString *dayOfTheWeek = [dateFormatterWeek stringFromDate:[NSDate date]];

    //Tuesday
    NSLog(@"%@", [dateFormatterWeek stringFromDate:[NSDate date]]);
    NSLog(@"returns %@", dayOfTheWeek);




    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponent = [NSDateComponents new];
    dayComponent.day = 1;

    NSDate* tomorrow = [calendar dateByAddingComponents:dayComponent toDate:today options:0];
    NSLog(@"tomorrow is%@", tomorrow);
    NSLog(@"dayComponent day is%ld", (long)dayComponent.day);



    NSDate *myCurrentDate = [NSDate date];
    NSLog(@"myCurrentDate is %@", myCurrentDate);

    int nextDay = dayComponent.day;

    for (int i =0; i< 7; i++) {
        NSString *myDayOfTheWeek = [dateFormatterWeek stringFromDate:currentDate];
        [self.daysOfWeek addObject:myDayOfTheWeek];

    }


     return dayOfTheWeek;
}

-(NSMutableArray*) setDates{

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponent = [NSDateComponents new];
    dayComponent.day = 0;

    NSDate *today = [NSDate date];

    for (int i=0; i<7; i++) {

        dayComponent.day =i;

        NSDate *currentDay = [calendar dateByAddingComponents:dayComponent toDate:today options:0];

        NSString *formatString = [NSDateFormatter dateFormatFromTemplate:@"EdMMM" options:0
                                                                  locale:[NSLocale currentLocale]];
        NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];

        [myDateFormatter setDateFormat:formatString];

        NSString *dayString = [myDateFormatter stringFromDate:currentDay];
        NSLog(@"daystring is %@", dayString);

        [self.days addObject:dayString];

        NSLog(@"day is: %@", [self.days objectAtIndex:i]);
    }
     NSLog(@"days are: %@", self.days);
    return self.days;
}

-(void)getObjectsFromParseAndCompareDates{
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
@end

