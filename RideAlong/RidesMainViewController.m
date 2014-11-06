//
//  RidesMainViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/5/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RidesMainViewController.h"
#import "Resort.h"
#import <MapKit/MapKit.h>

@interface RidesMainViewController ()<UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *ridesTableView;
@property (weak, nonatomic) IBOutlet MKMapView *ridesMapView;
@property NSArray *resorts;
//@property MKPointAnnotation *skiResortAnnotation;
@property CLLocationManager *locationManager;
@property NSArray *skiResorts;
@property NSMutableArray *resortsNames;
@property MKMapItem *skiResortMapItem ;


@end

@implementation RidesMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self addSkiResortLocation];
    [self findSkiLift];
//    self.skiResortAnnotation = [[MKPointAnnotation alloc]init];

      self.resortsNames = [[NSMutableArray alloc]init];
}

-(void)viewWillAppear:(BOOL)animated{
    [self findSkiLift];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.resortsNames.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    Resort  *myResort = [self.resortsNames objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];


    cell.textLabel.text =myResort.name;
//    NSLog(@"name %@",[self.resortsNames objectAtIndex:indexPath.row]);
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

//        Resort *resort = [[Resort alloc]init];
        self.skiResorts = response.mapItems;
        for (MKMapItem *mapItem in self.skiResorts)
        {
            MKPointAnnotation *skiResortAnnotation = [[MKPointAnnotation alloc] init];
            skiResortAnnotation.coordinate = mapItem.placemark.location.coordinate;
            skiResortAnnotation.title = mapItem.placemark.name;
            [self.ridesMapView addAnnotation:skiResortAnnotation];
//            [self.ridesMapView addAnnotations:self.skiResorts];

            Resort *resort = [[Resort alloc]init];

            resort.name =mapItem.name;

//            resort.name = skiResortAnnotation.title;

            [self.resortsNames addObject:resort];
//            NSLog(@"resorts %@", mapItem.placemark.location.coordinate);
             [self.ridesMapView addAnnotation:skiResortAnnotation];

//            NSLog(@" %@",mapItem.name);
            [self.ridesTableView reloadData];




            CLLocationCoordinate2D center = skiResortAnnotation.coordinate;

            MKCoordinateSpan span;
            span.latitudeDelta = 5;
            span.longitudeDelta = 5;

            MKCoordinateRegion region;
            region.center = center;
            region.span = span;
            
            [self.ridesMapView setRegion:region animated:YES];




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
        }

//        self.skiResortMapItem = self.skiResorts.firstObject;

//        self.myTextView.text =[NSString stringWithFormat:@" %@", mapItem.name];
    }];
}


-(MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{

    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"MyPinID"];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.image = [UIImage imageNamed:@"Flag"];
    return pin;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    CLLocationCoordinate2D center = view.annotation.coordinate;

    MKCoordinateSpan span;
    span.latitudeDelta = 0.05;
    span.longitudeDelta = 0.05;

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
