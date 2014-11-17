//
//  Comment.h
//  RideAlong
//
//  Created by Wade Sellers on 11/16/14.
//  Copyright (c) 2014 Wade Sellers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Comment : NSObject
@property NSString *commentText;
@property NSDate *dateTimeWritten;
@property NSString *authorId;

@end
