//
//  UIButton+CustomButton.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/6/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "UIButton+CustomButton.h"

@implementation UIButton (CustomButton)

/**
 *  Provides button for navigation bar
 *
 *  @return UIButton, configured button
 */
+ (UIButton *)nc_buttonForNavigationBar {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 80, 30);
    button.layer.borderColor = [UIColor blackColor].CGColor;
    button.layer.borderWidth = 1.0f;
    button.layer.cornerRadius = 15.0f;
    [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14.0f]];
    button.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.25f];
    
    return button;
}

@end
