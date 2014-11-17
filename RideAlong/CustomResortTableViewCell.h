//
//  CustomResortTableViewCell.h
//  RideAlong
//
//  Created by Wade Sellers on 11/17/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CustomResortTableViewCell : UITableViewCell

- (void)pullResortImage:(PFObject *)resortObject;

@end
