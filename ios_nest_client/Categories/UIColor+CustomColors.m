//
//  UIColor+CustomColors.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

+ (UIColor *)nc_heatingThermostatColor {
    return [UIColor colorWithRed:209.0f/255.0f green:68.0f/255.0f blue:17.0f/255.0f alpha:1.0f];
}

+ (UIColor *)nc_coolingThermostatColor {
    return [UIColor colorWithRed:3.0f/255.0f green:90.0f/255.0f blue:212.0f/255.0f alpha:1.0f];
}

+ (UIColor *)nc_neutralThermostatColor {
    return [UIColor colorWithRed:48.0f/255.0f green:48.0f/255.0f blue:48.0f/255.0f alpha:1.0f];
}

+ (UIColor *)nc_redSmokeCOAlarmColor {
    return [UIColor colorWithRed:215.0f/255.0f green:40.0f/255.0f blue:0.0f alpha:1.0f];
}

+ (UIColor *)nc_greenSmokeCOAlarmColor {
    return [UIColor colorWithRed:8.0f/255.0f green:213.0f/255.0f blue:10.0f/255.0f alpha:1.0f];
}

+ (UIColor *)nc_yellowSmokeCOAlarmColor {
    return [UIColor colorWithRed:1.0f green:190.0f/255.0f blue:0.0f alpha:1.0f];
}

+ (UIColor *)nc_greySmokeCOAlarmColor {
    return [UIColor colorWithRed:100.0f/255.0f green:100.0f/255.0f blue:100.0f/255.0f alpha:1.0f];
}

@end
