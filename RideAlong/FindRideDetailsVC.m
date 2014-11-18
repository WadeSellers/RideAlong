//
//  RideDetailsViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/4/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "FindRideDetailsVC.h"
#import "FindOrCreateRideVC.h"
#import <Parse/Parse.h>
#import "Comment.h"

@interface FindRideDetailsVC () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;
@property NSMutableArray *commentsArray;
@property PFObject *displayedRide;
@property (weak, nonatomic) IBOutlet UILabel *addressTextField;
@property (weak, nonatomic) IBOutlet UILabel *resortTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateTextField;
@property (weak, nonatomic) IBOutlet UITextView *detailsTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bookLiftButton;
@property (weak, nonatomic) IBOutlet UILabel *seatLabel;

@property (weak, nonatomic) IBOutlet UILabel *feeLabel;


@end

@implementation FindRideDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentsTextView.delegate = self;
    self.commentsArray = [NSMutableArray array];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self loadComments];
    self.addressTextField.text = self.tappedAnnotation.myPointAnnotation.rideObject[@"startName"];
    self.resortTextField.text = self.tappedAnnotation.myPointAnnotation.rideObject[@"endName"];

    NSDate *rideDateAndTime = [[NSDate alloc] init];
    rideDateAndTime = self.tappedAnnotation.myPointAnnotation.rideObject[@"date"];
    NSLog(@"ride object: %@", self.tappedAnnotation.myPointAnnotation.rideObject);
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d/yyyy @ h:mma"];
    NSLog(@"date: %@", [formatter stringFromDate:rideDateAndTime]);
    self.dateTextField.text = [formatter stringFromDate:rideDateAndTime];
    self.seatLabel.text = self.tappedAnnotation.myPointAnnotation.rideObject[@"seats"];
    self.feeLabel.text = self.tappedAnnotation.myPointAnnotation.rideObject[@"fee"];



    self.detailsTextView.text = self.tappedAnnotation.myPointAnnotation.rideObject[@"description"];

}

- (IBAction)onSendButtonPressed:(id)sender {

    PFObject *comment = [[PFObject alloc] initWithClassName:@"Comment"];
    comment[@"remark"] = self.commentsTextView.text;
    comment[@"ride"] = self.tappedAnnotation.myPointAnnotation.rideObject;
    comment[@"userId"] = [[NSUserDefaults standardUserDefaults] objectForKey:@"ApplicationUUIDKey"];
//    NSString *comment = [[NSString alloc] initWithString:self.commentsTextView.text];
    self.commentsTextView.text = @"Write a comment here...";

    [self dismissKeyboard];
//    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:self.commentsArray];
//    [tempArray addObject:comment];
//    [self.commentsArray addcomment];
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", [error userInfo]);
        }
        else
        {
            [self.commentsArray addObject:comment];
            [self.commentsTableView reloadData];
        }
//        [self loadComments];
    }];

}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
self.commentsTextView.text = @"";
}

-(void) loadComments
{
    PFQuery *thisRide = [PFQuery queryWithClassName:@"Comment"];
    [thisRide includeKey:@"ride"];
    [thisRide whereKey:@"ride" equalTo:self.tappedAnnotation.myPointAnnotation.rideObject];
    [thisRide findObjectsInBackgroundWithBlock:^(NSArray *comments, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error.userInfo);
//            self.commentsArray = [NSMutableArray array];
        }
        else
        {
            self.displayedRide = self.tappedAnnotation.myPointAnnotation.rideObject;
            self.commentsArray = [NSMutableArray arrayWithArray:comments];
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
    PFObject *comment = [self.commentsArray objectAtIndex:indexPath.row];

    if ([comment[@"userId"] isEqualToString: self.tappedAnnotation.myPointAnnotation.rideObject[@"driver"]])
    {
        cell.textLabel.text = @"Driver writes:";
    }
    else if ([comment[@"userId"] isEqualToString: self.tappedAnnotation.myPointAnnotation.rideObject[@"passenger"]])
    {
        cell.textLabel.text = @"Passenger writes:";
    }
    else
    {
        cell.textLabel.text = @"A potential rider writes:";
    }

    cell.detailTextLabel.text = comment[@"remark"];

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

- (void)showTheRideInfo:(PFObject *)rideObject
{

}
@end
