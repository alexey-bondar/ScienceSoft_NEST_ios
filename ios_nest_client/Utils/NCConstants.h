//
//  NCConstants.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/3/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kNestClientId;
extern NSString *const kNestClientSecret;
extern NSString *const kNestCurrentAPIDomain;
extern NSString *const kNestState;
extern NSString *const kRedirectURL;
extern NSString *const kCodeKey;
extern NSString *const kAuthTokenKey;
extern NSString *const kTokenKey;
extern NSString *const kExpiresInKey;
extern NSString *const kAuthCodeKey;
extern NSString *const kThermostatsKey;
extern NSString *const kProtectsKey;
extern NSString *const kCamerasKey;

extern NSUInteger const kRequestTimeout;

extern NSInteger const kThermostatMinC;
extern NSInteger const kThermostatMinF;
extern NSInteger const kThermostatMaxC;
extern NSInteger const kThermostatMaxF;

extern NSString *const kThermostatCell;
extern NSString *const kProtectCell;
extern NSString *const kCameraCell;

extern NSString *const kNameLong;
extern NSString *const kName;
extern NSString *const kBatteryHealth;
extern NSString *const kCOAlarmState;
extern NSString *const kSmokeAlarmState;
extern NSString *const kUIColorState;
extern NSString *const kIsOnline;
extern NSString *const kAppUrl;
extern NSString *const kWebUrl;
extern NSString *const kLastEvent;
extern NSString *const kFanTimerActive;
extern NSString *const kHasFan;
extern NSString *const kHasLeaf;
extern NSString *const kTargetTemperatureF;
extern NSString *const kTargetTemperatureHighF;
extern NSString *const kTargetTemperatureLowF;
extern NSString *const kAmbientTemperatureF;
extern NSString *const kTargetTemperatureC;
extern NSString *const kTargetTemperatureHighC;
extern NSString *const kTargetTemperatureLowC;
extern NSString *const kAmbientTemperatureC;
extern NSString *const kHumidity;
extern NSString *const kTemperatureScale;
extern NSString *const kHvacMode;
extern NSString *const kHvacState;

extern NSString *const kEmergency;
extern NSString *const kWarning;
extern NSString *const kReplace;
extern NSString *const kGreen;
extern NSString *const kYellow;
extern NSString *const kRed;

extern NSString *const kThermostatPath;
extern NSString *const kCameraPath;
extern NSString *const kProtectPath;

extern NSString *const kNCThermostatValueChangedNotification;
extern NSString *const kNCStructureUpdatedNotification;