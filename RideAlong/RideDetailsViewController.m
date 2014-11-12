//
//  RideDetailsViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/4/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RideDetailsViewController.h"
#import <Parse/Parse.h>

@interface RideDetailsViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;
@property NSArray *commentsArray;



@end

@implementation RideDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentsTextView.delegate = self;
    [self loadComments];
    self.commentsArray = [NSMutableArray array];
}
- (IBAction)onSendButtonPressed:(id)sender {

    NSString *commentString =self.commentsTextView.text;
    self.commentsTextView.text = @"";

    [self.resortObject[@"comments"] addObject:commentString];
    [self.resortObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", [error userInfo]);
        }
        [self.commentsTableView reloadData];
    }];

}


-(void)textViewDidBeginEditing:(UITextView *)textView{

self.commentsTextView.text = @"";
}

-(void) loadComments
{
    PFQuery *thisRide = [PFQuery queryWithClassName:@"Ride"];
    [thisRide whereKey:@"objectId" equalTo:self.resortObject[@"objectId"]];
    [thisRide findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", error.userInfo);
            self.commentsArray = [NSArray array];
        }
        else
        {
            self.commentsArray = objects;
            //NSLog(@"rides: %@", self.driverArray);
        }
    }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentsArray.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    PFObject *comment = [self.commentsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = comment[@"name"];
    cell.detailTextLabel.text = [self.commentsArray objectAtIndex:indexPath.row];

    return cell;
}

@end
