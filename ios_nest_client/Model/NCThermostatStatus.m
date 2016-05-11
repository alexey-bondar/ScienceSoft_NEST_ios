//
//  NCThermostatStatus.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "NCThermostatStatus.h"
#import "NCThermostat.h"

@interface NCThermostatStatus ()

- (void)_updateFanModeWithThermostat:(NCThermostat *)thermostat;
- (void)_updateCurrentTemperatureWithThermostat:(NCThermostat *)thermostat;
- (void)_updateTargetTemperatureWithThermostat:(NCThermostat *)thermostat;
- (void)_updateHeatingModeWithThermostat:(NCThermostat *)thermostat;

@end

@implementation NCThermostatStatus

- (instancetype)initWithThermostat:(NCThermostat *)thermostat {
    if (self = [super init]) {
        _temperatureScale = thermostat.temperatureScale;
        _humidity = [NSString stringWithFormat:@"%d%%", (int)thermostat.humidity];
        _title = thermostat.nameLong;
        
        [self _updateCurrentTemperatureWithThermostat:thermostat];
        [self _updateTargetTemperatureWithThermostat:thermostat];
        [self _updateFanModeWithThermostat:thermostat];
        [self _updateHeatingModeWithThermostat:thermostat];
    }
    
    return self;
}

#pragma mark - Private methods

/**
 *  Updates fan mode
 *
 *  @param thermostat NCThermostat, retrieved thermostat
 */
- (void)_updateFanModeWithThermostat:(NCThermostat *)thermostat {
    if (thermostat.hasFan) {
        _fanMode = NCThermostatFanModeFan;
    } else if (thermostat.hasLeaf) {
        _fanMode = NCThermostatFanModeLeaf;
    } else {
        _fanMode = NCThermostatFanModeOff;
    }
    
    if (thermostat.hvacMode == NCThermostatHvacModeOff) {
        _fanMode = NCThermostatFanModeOff;
    }
}

/**
 *  Updates current temperature
 *
 *  @param thermostat NCThermostat, retrieved thermostat
 */
- (void)_updateCurrentTemperatureWithThermostat:(NCThermostat *)thermostat {
    NSInteger currentTemperature = thermostat.temperatureScaleType == NCThermostatTemperatureScaleF ? thermostat.ambientTemperatureF : thermostat.ambientTemperatureC;
    _currentTemperature = [NSString stringWithFormat:@"%d°%@", (int)currentTemperature, thermostat.temperatureScale];
}

/**
 *  Updates target temperature
 *
 *  @param thermostat NCThermostat, retrieved thermostat
 */
- (void)_updateTargetTemperatureWithThermostat:(NCThermostat *)thermostat {
    NSInteger targetTemperature = thermostat.temperatureScaleType == NCThermostatTemperatureScaleF ? thermostat.targetTemperatureF : thermostat.targetTemperatureC;
    NSInteger targetTemperatureLow = thermostat.temperatureScaleType == NCThermostatTemperatureScaleF ? thermostat.targetTemperatureLowF : thermostat.targetTemperatureLowC;
    NSInteger targetTemperatureHigh = thermostat.temperatureScaleType == NCThermostatTemperatureScaleF ? thermostat.targetTemperatureHighF : thermostat.targetTemperatureHighC;
    switch (thermostat.hvacMode) {
        case NCThermostatHvacModeOff:
            _targetTemperature = NSLocalizedString(@"thermostatStatus_off", nil);
            _temperatureScale = nil;
            break;
        case NCThermostatHvacModeHeatCool:
            _targetTemperature = [NSString stringWithFormat:@"%d-%d", (int)targetTemperatureLow, (int)targetTemperatureHigh];
            break;
        case NCThermostatHvacModeCool:
        case NCThermostatHvacModeHeat:
            _targetTemperature = [NSString stringWithFormat:@"%d", (int)targetTemperature];
            break;
    }
}

/**
 *  Updates heating mode
 *
 *  @param thermostat NCThermostat, retrieved thermostat
 */
- (void)_updateHeatingModeWithThermostat:(NCThermostat *)thermostat {
    if (thermostat.hvacState == NCThermostatHvacStateHeating &&
        (thermostat.hvacMode == NCThermostatHvacModeHeat || thermostat.hvacMode == NCThermostatHvacModeHeatCool)) {
        _heatingMode = NCThermostatModeHeating;
    } else if (thermostat.hvacState == NCThermostatHvacStateCooling &&
               (thermostat.hvacMode == NCThermostatHvacModeCool || thermostat.hvacMode == NCThermostatHvacModeHeatCool)) {
        _heatingMode = NCThermostatModeCooling;
    } else {
        _heatingMode = NCThermostatModeNeutral;
    }
}

@end
