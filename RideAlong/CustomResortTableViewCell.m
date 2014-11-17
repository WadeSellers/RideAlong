//
//  CustomResortTableViewCell.m
//  RideAlong
//
//  Created by Wade Sellers on 11/17/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import "CustomResortTableViewCell.h"

@implementation CustomResortTableViewCell


- (void)pullResortImage:(PFObject *)resortObject
{
    PFFile *resortFile = resortObject[@"logo"];
    [resortFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (error)
        {
            NSLog(@"%@", error);
        }
        else
        {
            self.imageView.image = [UIImage imageWithData:imageData];
            [self setNeedsLayout];
        }
    }];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
