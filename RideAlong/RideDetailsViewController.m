//
//  RideDetailsViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/4/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RideDetailsViewController.h"
#import "RideOrDriveViewController.h"
#import <Parse/Parse.h>

@interface RideDetailsViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;
@property NSArray *commentsArray;
@property PFObject *displayedRide;
@property (weak, nonatomic) IBOutlet UILabel *addressTextField;
@property (weak, nonatomic) IBOutlet UILabel *resortTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateTextField;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bookLiftButton;



@end

@implementation RideDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentsTextView.delegate = self;
    [self loadComments];
    self.commentsArray = [NSMutableArray array];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:tap];

//    if (self.tappedAnnotation.myPointAnnotation.rideObject[@"passenger"] == [[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationUUIDKey"])
//    {
//        self.bookLiftButton.title = @"You're Booked!";
//        [self.bookLiftButton setEnabled:NO];
//    }
//    else if (self.tappedAnnotation.myPointAnnotation.rideObject[@"driver"] == [[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationUUIDKey"])
//    {
//        self.bookLiftButton.title = @"Your Ride!";
//        [self.bookLiftButton setEnabled:NO];
//    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self loadComments];
    NSLog(@"***** %@ *****", self.tappedAnnotation.myPointAnnotation.rideObject);
    self.addressTextField.text = self.tappedAnnotation.myPointAnnotation.rideObject[@"startName"];
    self.resortTextField.text = self.tappedAnnotation.myPointAnnotation.rideObject[@"endName"];
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter = self.tappedAnnotation.myPointAnnotation.rideObject[@"date"];
    //self.dateTextField.text = [dateFormatter dateFromString:self.tappedAnnotation.myPointAnnotation.rideObject[@"date"]];
    self.detailsTextView.text = self.tappedAnnotation.myPointAnnotation.rideObject[@"description"];

}

- (IBAction)onSendButtonPressed:(id)sender {

    NSString *commentString =self.commentsTextView.text;
    self.commentsTextView.text = @"Write a comment here...";
    [self dismissKeyboard];

    [self.tappedAnnotation.myPointAnnotation.rideObject[@"comments"] addObject:commentString];
    [self.tappedAnnotation.myPointAnnotation.rideObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", [error userInfo]);
        }
        [self loadComments];
    }];

}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
self.commentsTextView.text = @"";
}

-(void) loadComments
{
    PFQuery *thisRide = [PFQuery queryWithClassName:@"Ride"];
    [thisRide whereKey:@"objectId" equalTo:self.tappedAnnotation.myPointAnnotation.rideObject.objectId];
    [thisRide findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error.userInfo);
            self.commentsArray = [NSArray array];
        }
        else
        {
            self.displayedRide = [objects firstObject];
            self.commentsArray = self.displayedRide[@"comments"];
            NSLog(@"**** rides: %@ ****", self.commentsArray);
        }
        [self.commentsTableView reloadData];
    }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentsArray.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
//    PFObject *comment = [self.commentsArray objectAtIndex:indexPath.row];
    NSString *comment = [self.commentsArray objectAtIndex:indexPath.row];

//    cell.textLabel.text = comment[@"name"];
    cell.textLabel.text = comment;

    cell.detailTextLabel.text = [self.commentsArray objectAtIndex:indexPath.row];

    return cell;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.commentsTextView endEditing:YES];

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

- (void)dismissKeyboard
{
    [self.commentsTextView resignFirstResponder];
    if ([self.commentsTextView.text isEqualToString:@""])
    {
        self.commentsTextView.text = @"Write a comment here...";
    }
}
@end
