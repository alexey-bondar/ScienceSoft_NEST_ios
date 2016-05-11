//
//  NCThermostate.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/4/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "NCThermostat.h"

@implementation NCThermostat

#pragma mark - Customized Setters

/**
 *  Converts string to enum
 *
 *  @param temperatureScale NSString, retrieved temperature scale string
 */
- (void)setTemperatureScale:(NSString *)temperatureScale {
    _temperatureScale = temperatureScale;
    if ([temperatureScale isEqualToString:@"F"]) {
        _temperatureScaleType = NCThermostatTemperatureScaleF;
    } else {
        _temperatureScaleType = NCThermostatTemperatureScaleC;
    }
}

#pragma mark - Helpers

/**
 *  Converts string to enum
 *
 *  @param hvacMode NSString, retrieved hvac mode string
 */
- (void)updateHvacMode:(NSString *)hvacMode {
    if ([hvacMode isEqualToString:@"heat"]) {
        self.hvacMode = NCThermostatHvacModeHeat;
    } else if ([hvacMode isEqualToString:@"cool"]) {
        self.hvacMode = NCThermostatHvacModeCool;
    } else if ([hvacMode isEqualToString:@"heat-cool"]) {
        self.hvacMode = NCThermostatHvacModeHeatCool;
    } else {
        self.hvacMode = NCThermostatHvacModeOff;
    }
}

/**
 *  Converts string to enum
 *
 *  @param hvacState NSString, retrieved hvac state string
 */
- (void)updateHvacState:(NSString *)hvacState {
    if ([hvacState isEqualToString:@"heating"]) {
        self.hvacState = NCThermostatHvacStateHeating;
    } else if ([hvacState isEqualToString:@"cooling"]) {
        self.hvacState = NCThermostatHvacStateCooling;
    } else {
        self.hvacState = NCThermostatHvacStateOff;
    }
}

@end
