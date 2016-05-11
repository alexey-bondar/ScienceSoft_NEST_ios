//
//  NCThermostatStatus.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NCThermostat;

typedef NS_ENUM(NSInteger, NCThermostatFanMode) {
    NCThermostatFanModeFan,
    NCThermostatFanModeLeaf,
    NCThermostatFanModeOff
};

typedef NS_ENUM(NSInteger, NCThermostatMode) {
    NCThermostatModeHeating,
    NCThermostatModeCooling,
    NCThermostatModeNeutral
};

@interface NCThermostatStatus : NSObject

@property (nonatomic, assign) NCThermostatFanMode fanMode;
@property (nonatomic, strong) NSString *targetTemperature;
@property (nonatomic, strong) NSString *currentTemperature;
@property (nonatomic, strong) NSString *humidity;
@property (nonatomic, strong) NSString *temperatureScale;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NCThermostatMode heatingMode;

- (instancetype)initWithThermostat:(NCThermostat *)thermostat;

@end
