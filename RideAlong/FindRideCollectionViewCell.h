//
//  FindRideCollectionViewCell.h
//  RideAlong
//
//  Created by Edik Shklyar on 11/18/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindRideCollectionViewCell : UICollectionViewCell

@property NSString *myString;

@property (weak, nonatomic) IBOutlet UIButton *findRideButton;

- (IBAction)onFindRideButtonPressed:(UIButton *)sender;

@end
