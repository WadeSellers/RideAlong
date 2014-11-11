//
//  RideDetailsViewController.m
//  RideAlong
//
//  Created by Wade Sellers on 11/4/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "RideDetailsViewController.h"
#import <Parse/Parse.h>
#import "Ride.h"

@interface RideDetailsViewController () <UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;
@property NSMutableArray * commentsMutableArray;



@end

@implementation RideDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.commentsTextView.delegate = self;
    [self loadComments];
    self.commentsMutableArray = [NSMutableArray array];
}
- (IBAction)onSaveTabButtonPressed:(id)sender {

    NSString *commentString =self.commentsTextView.text;
    [self.commentsMutableArray addObject:commentString];
    self.commentsTextView.text = @"";
    [self.commentsTableView reloadData];

    [self.resortObject[@"comments"] addObject: self.commentsTextView.text];
    
    [self.resortObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@", [error userInfo]);
        }
    }];


}

-(void)textViewDidBeginEditing:(UITextView *)textView{

self.commentsTextView.text = @"";
}

-(void) loadComments{
//    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Ride"];
//    request.sortDescriptors =[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"comment" ascending:YES]];
//    self.commentsMutableArray = [self.managedObjectContext executeFetchRequest:request error:nil];
//    [self.tableView reloadData];
//
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentsMutableArray.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
//    PFObject *comment = [self.commentsMutableArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = comment[@"name"];
    cell.textLabel.text = [self.commentsMutableArray objectAtIndex:indexPath.row];

    return cell;
}

@end
