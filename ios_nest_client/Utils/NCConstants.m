//
//  NCConstants.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/3/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NCConstants.h"

NSString *const kNestClientId = @"303199da-f9c9-464a-9e99-603e0b3d7a99";
NSString *const kNestClientSecret = @"yIsBja4tIPPIQvd04a4YD2aDj";
NSString *const kNestCurrentAPIDomain = @"home.nest.com";
NSString *const kNestState = @"SOMESTATE";
NSString *const kRedirectURL = @"https://www.scnsoft.com";
NSString *const kCodeKey = @"code";
NSString *const kAuthTokenKey = @"access_token";
NSString *const kTokenKey = @"token";
NSString *const kExpiresInKey = @"expires_in";
NSString *const kAuthCodeKey = @"authorizationCode";
NSString *const kThermostatsKey = @"thermostats";
NSString *const kProtectsKey = @"smoke_co_alarms";
NSString *const kCamerasKey = @"cameras";

NSUInteger const kRequestTimeout = 60;

NSInteger const kThermostatMinC = 9;
NSInteger const kThermostatMinF = 48;
NSInteger const kThermostatMaxC = 32;
NSInteger const kThermostatMaxF = 90;

NSString *const kThermostatCell = @"NCThermostateCell";
NSString *const kProtectCell = @"NCProtectCell";
NSString *const kCameraCell = @"NCCameraCell";

NSString *const kNameLong = @"name_long";
NSString *const kName = @"name";
NSString *const kBatteryHealth = @"battery_health";
NSString *const kCOAlarmState = @"co_alarm_state";
NSString *const kSmokeAlarmState = @"smoke_alarm_state";
NSString *const kUIColorState = @"ui_color_state";
NSString *const kIsOnline = @"is_online";
NSString *const kAppUrl = @"app_url";
NSString *const kWebUrl = @"web_url";
NSString *const kLastEvent = @"last_event";
NSString *const kFanTimerActive = @"fan_timer_active";
NSString *const kHasFan = @"has_fan";
NSString *const kHasLeaf = @"has_leaf";
NSString *const kTargetTemperatureF = @"target_temperature_f";
NSString *const kTargetTemperatureHighF = @"target_temperature_high_f";
NSString *const kTargetTemperatureLowF = @"target_temperature_low_f";
NSString *const kAmbientTemperatureF = @"ambient_temperature_f";
NSString *const kTargetTemperatureC = @"target_temperature_c";
NSString *const kTargetTemperatureHighC = @"target_temperature_high_c";
NSString *const kTargetTemperatureLowC = @"target_temperature_low_c";
NSString *const kAmbientTemperatureC = @"ambient_temperature_c";
NSString *const kHumidity = @"humidity";
NSString *const kTemperatureScale = @"temperature_scale";
NSString *const kHvacMode = @"hvac_mode";
NSString *const kHvacState = @"hvac_state";

NSString *const kEmergency = @"emergency";
NSString *const kWarning = @"warning";
NSString *const kReplace = @"replace";
NSString *const kGreen = @"green";
NSString *const kYellow = @"yellow";
NSString *const kRed = @"red";

NSString *const kThermostatPath = @"devices/thermostats";
NSString *const kCameraPath = @"devices/cameras";
NSString *const kProtectPath = @"devices/smoke_co_alarms";

NSString *const kNCThermostatValueChangedNotification = @"NCThermostatValueChangedNotification";
NSString *const kNCStructureUpdatedNotification = @"NCStructureUpdatedNotification";