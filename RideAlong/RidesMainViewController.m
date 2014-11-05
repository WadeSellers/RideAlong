//
//  RidesMainViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/5/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RidesMainViewController.h"
#import "Ride.h"
#import <MapKit/MapKit.h>

@interface RidesMainViewController ()<UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ridesTableView;
@property (weak, nonatomic) IBOutlet MKMapView *ridesMapView;
@property NSArray *rides;
@property MKPointAnnotation *skiResortAnnotation;
@property CLLocationManager *locationManager;
@property NSArray *skiResorts;
@property MKMapItem *skiResortMapItem ;

@end

@implementation RidesMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addSkiResortLocation];
    [self findSkiLift];
    self.skiResortAnnotation = [[MKPointAnnotation alloc]init];


}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.rides.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    Ride  *ride = [self.rides objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    cell.textLabel.text =ride.name;
    return cell;
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
- (void) findSkiLift
//:(CLLocation *)location
{
    MKLocalSearchRequest *request = [MKLocalSearchRequest new];
    request.naturalLanguageQuery =@"Colorado Ski Resort";
//    request.region = MKCoordinateRegionMake(location.coordinate, MKCoordinateSpanMake(1, 1));
    MKLocalSearch *search = [[MKLocalSearch alloc]initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        self.skiResorts = response.mapItems;
        for (MKMapItem *mapItem in self.skiResorts)
        {

            self.skiResortAnnotation= mapItem.placemark;
            [self.ridesMapView addAnnotation:self.skiResortAnnotation];
//            [self.ridesMapView addAnnotations:self.skiResorts];
            NSLog(@" %@",mapItem.name);
        }

//        self.skiResortMapItem = self.skiResorts.firstObject;

//        self.myTextView.text =[NSString stringWithFormat:@" %@", mapItem.name];
    }];
}


-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MyPinID"];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.image = [UIImage imageNamed:@"PinImage"];

    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    CLLocationCoordinate2D center = view.annotation.coordinate;

    MKCoordinateSpan span;
    span.latitudeDelta = 0.01;
    span.longitudeDelta = 0.01;

    MKCoordinateRegion region;
    region.center = center;
    region.span = span;

    [self.ridesMapView setRegion:region animated:YES];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
