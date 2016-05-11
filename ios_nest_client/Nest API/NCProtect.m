//
//  NCProtect.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "NCProtect.h"

@implementation NCProtect

#pragma mark - Helpers

/**
 *  Converts string to enum
 *
 *  @param uiColorState NSString, retrieved uiColorState string
 */
- (void)updateUIColorState:(NSString *)uiColorState {
    if ([uiColorState isEqualToString:kGreen]) {
        _uiColorState = NCProtectColorStateGreen;
    } else if ([uiColorState isEqualToString:kRed]) {
        _uiColorState = NCProtectColorStateRed;
    } else if ([uiColorState isEqualToString:kYellow]) {
        _uiColorState = NCProtectColorStateYellow;
    } else {
        _uiColorState = NCProtectColorStateGrey;
    }
}

- (void)generateUIColorState {
    if ([self.coAlarmState isEqualToString:kEmergency] ||
        [self.smokeAlarmState isEqualToString:kEmergency]) {
        _uiColorState = NCProtectColorStateRed;
    } else if ([self.coAlarmState isEqualToString:kWarning] ||
               [self.smokeAlarmState isEqualToString:kWarning] ||
               [self.batteryHealth isEqualToString:kReplace]) {
        _uiColorState = NCProtectColorStateYellow;
    } else {
        _uiColorState = NCProtectColorStateGreen;
    }
    
    if (!self.isOnline) {
        _uiColorState = NCProtectColorStateGrey;
    }
}

@end
