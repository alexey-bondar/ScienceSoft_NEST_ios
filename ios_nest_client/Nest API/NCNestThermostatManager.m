//
//  NCNestThermostatManager.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/4/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "NCNestThermostatManager.h"
#import "NCFirebaseManager.h"
#import "NCThermostat.h"

@interface NCNestThermostatManager ()

@property (nonatomic, strong) id<NCFirebaseManagerProtocol> firebaseManager;

@end

@implementation NCNestThermostatManager

- (instancetype)init {
    if (self = [super init]) {
        _firebaseManager = [NCFirebaseManager sharedInstance];
    }
    return self;
}

/**
 *  Sets up a new Firebase connection for the thermostat provided and observes for any change in /devices/thermostats/thermostatId
 *
 *  @param thermostat NCThermostat, the thermostat you want to watch changes for
 */
- (void)beginSubscriptionForThermostat:(NCThermostat *)thermostat {
    __weak typeof(self) welf = self;
    [self.firebaseManager addSubscriptionToURL:[NSString stringWithFormat:@"devices/thermostats/%@/", thermostat.thermostatId] withBlock:^(FDataSnapshot *snapshot) {
        DDLogInfo(@"Values for URL: %@ were updated", [NSString stringWithFormat:@"%@/%@/", kThermostatPath, thermostat.thermostatId]);
        [welf updateThermostat:thermostat forStructure:snapshot.value];
    }];
}

/**
 *  Parse thermostat structure and put it in the thermostat object. Then send the updated object with notification.
 *
 *  @param thermostat NCThermostat, the thermostat you wish to update
 *  @param structure  NSDictionary, he structure you wish to update the thermostat with
 */
- (void)updateThermostat:(NCThermostat *)thermostat forStructure:(NSDictionary *)structure
{
    if ([structure objectForKey:kAmbientTemperatureF]) {
        thermostat.ambientTemperatureF = [[structure objectForKey:kAmbientTemperatureF] integerValue];
    }
    if ([structure objectForKey:kTargetTemperatureF]) {
        thermostat.targetTemperatureF = [[structure objectForKey:kTargetTemperatureF] integerValue];
    }
    if ([structure objectForKey:kTargetTemperatureHighF]) {
        thermostat.targetTemperatureHighF = [[structure objectForKey:kTargetTemperatureHighF] integerValue];
    }
    if ([structure objectForKey:kTargetTemperatureLowF]) {
        thermostat.targetTemperatureLowF = [[structure objectForKey:kTargetTemperatureLowF] integerValue];
    }
    if ([structure objectForKey:kAmbientTemperatureC]) {
        thermostat.ambientTemperatureC = [[structure objectForKey:kAmbientTemperatureC] integerValue];
    }
    if ([structure objectForKey:kTargetTemperatureC]) {
        thermostat.targetTemperatureC = [[structure objectForKey:kTargetTemperatureC] integerValue];
    }
    if ([structure objectForKey:kTargetTemperatureHighC]) {
        thermostat.targetTemperatureHighC = [[structure objectForKey:kTargetTemperatureHighC] integerValue];
    }
    if ([structure objectForKey:kTargetTemperatureLowC]) {
        thermostat.targetTemperatureLowC = [[structure objectForKey:kTargetTemperatureLowC] integerValue];
    }
    if ([structure objectForKey:kHasFan]) {
        thermostat.hasFan = [[structure objectForKey:kHasFan] boolValue];
    }
    if ([structure objectForKey:kHasLeaf]) {
        thermostat.hasLeaf = [[structure objectForKey:kHasLeaf] boolValue];
    }
    if ([structure objectForKey:kFanTimerActive]) {
        thermostat.fanTimerActive = [[structure objectForKey:kFanTimerActive] boolValue];
    }
    if ([structure objectForKey:kNameLong]) {
        thermostat.nameLong = [structure objectForKey:kNameLong];
    }
    if ([structure objectForKey:kName]) {
        thermostat.name = [structure objectForKey:kName];
    }
    if ([structure objectForKey:kHumidity]) {
        thermostat.humidity = [[structure objectForKey:kHumidity] integerValue];
    }
    if ([structure objectForKey:kTemperatureScale]) {
        thermostat.temperatureScale = [structure objectForKey:kTemperatureScale];
    }
    if ([structure objectForKey:kHvacMode]) {
        [thermostat updateHvacMode:[structure objectForKey:kHvacMode]];
    }
    if ([structure objectForKey:kHvacState]) {
        [thermostat updateHvacState:[structure objectForKey:kHvacState]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNCThermostatValueChangedNotification object:thermostat];
}

/**
 *  Sets the thermostat values by using the Firebase API
 *
 *  @param thermostat NCThermostat, the thermost you wish to save
 */
- (void)saveChangesForThermostat:(NCThermostat *)thermostat
{
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    
    if (thermostat.temperatureScaleType == NCThermostatTemperatureScaleF) {
        [values setValue:[NSNumber numberWithInteger:thermostat.targetTemperatureF] forKey:kTargetTemperatureF];
    } else {
        [values setValue:[NSNumber numberWithInteger:thermostat.targetTemperatureC] forKey:kTargetTemperatureC];
    }
    
    [self.firebaseManager setValues:values forURL:[NSString stringWithFormat:@"%@/%@/", kThermostatPath, thermostat.thermostatId]];
}

@end
