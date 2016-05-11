//
//  NCProtectStatus.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "NCProtectStatus.h"
#import "UIColor+CustomColors.h"

@implementation NCProtectStatus

- (instancetype)initWithProtect:(NCProtect *)protect {
    if (self = [super init]) {
        _title = protect.nameLong;
        _uiColorState = protect.uiColorState;
        _smokeAlarmState = protect.smokeAlarmState;
        _coAlarmState = protect.coAlarmState;
        _batteryHealth = protect.batteryHealth;
        _isOnline = protect.isOnline;
    }
    
    return self;
}

#pragma mark - State colors

/**
 *  Provides color of the smoke state
 *
 *  @return UIColor, smoke alarm color
 */
- (UIColor *)smokeAlarmStateColor {
    if (!self.isOnline) {
        return [UIColor nc_greySmokeCOAlarmColor];
    }
    
    if ([self.smokeAlarmState isEqualToString:kEmergency]) {
        return [UIColor nc_redSmokeCOAlarmColor];
    } else if ([self.smokeAlarmState isEqualToString:kWarning]) {
        return [UIColor nc_yellowSmokeCOAlarmColor];
    } else {
        return [UIColor nc_greenSmokeCOAlarmColor];
    }
}

/**
 *  Provides color of the CO state
 *
 *  @return UIColor, CO alarm color
 */
- (UIColor *)coAlarmStateColor {
    if (!self.isOnline) {
        return [UIColor nc_greySmokeCOAlarmColor];
    }
    
    if ([self.coAlarmState isEqualToString:kEmergency]) {
        return [UIColor nc_redSmokeCOAlarmColor];
    } else if ([self.coAlarmState isEqualToString:kWarning]) {
        return [UIColor nc_yellowSmokeCOAlarmColor];
    } else {
        return [UIColor nc_greenSmokeCOAlarmColor];
    }
}

/**
 *  Provides color of the battery state
 *
 *  @return UIColor, battery alarm color
 */
- (UIColor *)batteryAlarmStateColor {
    if (!self.isOnline) {
        return [UIColor nc_greySmokeCOAlarmColor];
    }
    
    if ([self.batteryHealth isEqualToString:kReplace]) {
        return [UIColor nc_yellowSmokeCOAlarmColor];
    } else {
        return [UIColor nc_greenSmokeCOAlarmColor];
    }
}

@end
