//
//  UIButton+PrimaryButton.m
//  Flowgro
//
//  Created by Wade Sellers on 1/27/15.
//  Copyright (c) 2015 Flowhub. All rights reserved.
//

#import "UIButton+PrimaryButton.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIButton (PrimaryButton)

- (void)setupButton:(NSString *)title setEnabled:(BOOL)enabled setVisible:(BOOL)visible
{
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateDisabled];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:19.0];

    [[self layer] setBorderWidth:1.0];
    [[self layer] setCornerRadius:5.0];
    self.clipsToBounds = YES;

    if (enabled)
    {
        [self enableWithPresets];
    }
    else
    {
        [self disableWithPresets];
    }

    if (visible)
    {
        self.alpha = 1.0;
    }
    else
    {
        self.alpha = 0.0;
    }
}

- (void)fadeInWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^
    {
        self.alpha = 1.0;
    }
                     completion:nil];
}

- (void)fadeOutWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay
{
    [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveEaseIn animations:^
     {
         self.alpha = 0.0;
     }
                     completion:nil];
}

- (void)pulsateBorderWithStartValue:(float)start andEndValue:(float)end andDuration:(CFTimeInterval)duration
{
    CABasicAnimation *borderAnimation = [CABasicAnimation animationWithKeyPath:@"borderWidth"];
    [borderAnimation setFromValue:[NSNumber numberWithFloat:start]];
    [borderAnimation setToValue:[NSNumber numberWithFloat:(end)]];
    [borderAnimation setAutoreverses:YES];
    [borderAnimation setDuration:duration];
    [borderAnimation setRepeatCount:HUGE_VALF];
    [self.layer addAnimation:borderAnimation forKey:@"animateBorder"];
}

- (void) enableWithPresets
{
    self.enabled = YES;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[self layer] setBorderColor:[UIColor whiteColor].CGColor];
}

- (void) disableWithPresets
{
    self.enabled = NO;
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [[self layer] setBorderColor:[UIColor grayColor].CGColor];
}
















@end
