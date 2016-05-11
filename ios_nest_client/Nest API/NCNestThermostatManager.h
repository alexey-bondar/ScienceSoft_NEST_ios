//
//  NCNestThermostatManager.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/4/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NCThermostat;

@interface NCNestThermostatManager : NSObject

- (void)beginSubscriptionForThermostat:(NCThermostat *)thermostat;
- (void)saveChangesForThermostat:(NCThermostat *)thermostat;

@end
