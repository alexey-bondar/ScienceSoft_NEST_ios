//
//  NCProtectStatus.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCProtect.h"

typedef NS_ENUM(NSInteger, NCBatteryState) {
    NCBatteryStateOk,
    NCBatteryStateReplace
};

typedef NS_ENUM(NSInteger, NCAlarmState) {
    NCAlarmStateOk,
    NCAlarmStateWarning,
    NCAlarmStateEmergency
};

@interface NCProtectStatus : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NCProtectColorState uiColorState;
@property (nonatomic, strong) NSString *batteryHealth;
@property (nonatomic, strong) NSString *coAlarmState;
@property (nonatomic, strong) NSString *smokeAlarmState;
@property (nonatomic, assign) BOOL isOnline;

- (instancetype)initWithProtect:(NCProtect *)protect;
- (UIColor *)coAlarmStateColor;
- (UIColor *)smokeAlarmStateColor;
- (UIColor *)batteryAlarmStateColor;

@end
