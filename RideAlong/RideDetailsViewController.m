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

@interface RideDetailsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *commentsTableView;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextView;
@property NSMutableArray * commentsMutableArray;



@end

@implementation RideDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 [self loadComments];}

//-(void) loadComments{
//    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Ride"];
//    request.sortDescriptors =[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"comment" ascending:YES]];
//    self.commentsMutableArray = [self.managedObjectContext executeFetchRequest:request error:nil];
//    [self.tableView reloadData];
//}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentsTableView.count;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    Ride  *ride = [self.commentsMutableArray objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    cell.textLabel.text =ride.name;
    return cell;
}




@end
