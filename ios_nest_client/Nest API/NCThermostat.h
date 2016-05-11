//
//  NCThermostate.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/4/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NCThermostatTemperatureScale) {
    NCThermostatTemperatureScaleC,
    NCThermostatTemperatureScaleF
};

typedef NS_ENUM(NSInteger, NCThermostatHvacMode) {
    NCThermostatHvacModeHeat,
    NCThermostatHvacModeCool,
    NCThermostatHvacModeHeatCool,
    NCThermostatHvacModeOff
};

typedef NS_ENUM(NSInteger, NCThermostatHvacState) {
    NCThermostatHvacStateHeating,
    NCThermostatHvacStateCooling,
    NCThermostatHvacStateOff
};

@interface NCThermostat : NSObject

@property (nonatomic, strong) NSString *thermostatId;
@property (nonatomic, strong) NSString *nameLong;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL hasFan;
@property (nonatomic, assign) BOOL hasLeaf;
@property (nonatomic, assign) BOOL fanTimerActive;
@property (nonatomic, assign) NSInteger humidity;
@property (nonatomic, assign) NSInteger ambientTemperatureF;
@property (nonatomic, assign) NSInteger targetTemperatureF;
@property (nonatomic, assign) NSInteger targetTemperatureHighF;
@property (nonatomic, assign) NSInteger targetTemperatureLowF;
@property (nonatomic, assign) NSInteger ambientTemperatureC;
@property (nonatomic, assign) NSInteger targetTemperatureC;
@property (nonatomic, assign) NSInteger targetTemperatureHighC;
@property (nonatomic, assign) NSInteger targetTemperatureLowC;
@property (nonatomic, strong) NSString *temperatureScale;
@property (nonatomic, assign) NCThermostatTemperatureScale temperatureScaleType;
@property (nonatomic, assign) NCThermostatHvacState hvacState;
@property (nonatomic, assign) NCThermostatHvacMode hvacMode;

- (void)updateHvacState:(NSString *)hvacState;
- (void)updateHvacMode:(NSString *)hvacMode;

@end
