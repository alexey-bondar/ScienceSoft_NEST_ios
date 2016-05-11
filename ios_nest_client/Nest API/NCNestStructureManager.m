//
//  NSNestStructureManager.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/4/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "NCNestStructureManager.h"
#import "NCThermostat.h"
#import "NCProtect.h"
#import "NCCamera.h"
#import "NCFirebaseManager.h"

@interface NCNestStructureManager ()

@property (nonatomic, strong) id<NCFirebaseManagerProtocol> firebaseManager;

@end

@implementation NCNestStructureManager

- (instancetype)init {
    if (self = [super init]) {
        _firebaseManager = [NCFirebaseManager sharedInstance];
    }
    return self;
}

/**
 * Gets the entire structure and converts it to devices objects and returns its as a dictionary
 */
- (void)initialize {
    __weak typeof(self) welf = self;
    [self.firebaseManager addSubscriptionToURL:@"structures/" withBlock:^(FDataSnapshot *snapshot) {
        [welf parseStructure:snapshot.value];
    }];
}

/**
 * Parse the structure and send it back to the delegate
 *
 * @param structure NSDictionary, the structure you want to parse
 */
- (void)parseStructure:(NSDictionary *)structure {
    NSArray *thermostats = [self thermostatsForStructure:structure];
    NSArray *protects = [self protectsForStructure:structure];
    NSArray *cameras = [self camerasForStructure:structure];
    
    NSMutableDictionary *returnStructure = [[NSMutableDictionary alloc] init];
    
    if (thermostats) {
        [returnStructure setObject:thermostats forKey:kThermostatsKey];
    }
    if (protects) {
        [returnStructure setObject:protects forKey:kProtectsKey];
    }
    if (cameras) {
        [returnStructure setObject:cameras forKey:kCamerasKey];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNCStructureUpdatedNotification object:returnStructure];
}

/**
 *  Creates new thermostats for the given structure
 *
 *  @param structure NSDictionary, the structure you want to create thermostats for
 *
 *  @return the list of thermostats in the structure in an NSArray
 */
- (NSArray *)thermostatsForStructure:(NSDictionary *)structure {
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [structure allKeys].count; i++) {
        NSString *structureId = [[structure allKeys] objectAtIndex:i];
        
        NSArray *thermostatIds = [[structure objectForKey:structureId] objectForKey:kThermostatsKey];
        
        if (!thermostatIds || [thermostatIds count] == 0) {
            continue;
        } else {
            for (int i = 0; i < [thermostatIds count]; i++) {
                NCThermostat *thermostat = [NCThermostat new];
                thermostat.thermostatId = [thermostatIds objectAtIndex:i];
                [returnArray addObject:thermostat];
            }
        }
    }
    
    return returnArray;
}

/**
 *  Creates new smoke+co alarms for the given structure
 *
 *  @param structure NSDictionary, the structure you want to create smoke+co alarms for
 *
 *  @return the list of smoke+co alarms in the structure in an NSArray
 */
- (NSArray *)protectsForStructure:(NSDictionary *)structure {
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [structure allKeys].count; i++) {
        NSString *structureId = [[structure allKeys] objectAtIndex:i];
        
        NSArray *protectsIds = [[structure objectForKey:structureId] objectForKey:kProtectsKey];
        
        if (!protectsIds || [protectsIds count] == 0) {
            continue;
        } else {
            for (int i = 0; i < [protectsIds count]; i++) {
                NCProtect *protect = [NCProtect new];
                protect.protectId = [protectsIds objectAtIndex:i];
                [returnArray addObject:protect];
            }
        }
    }
    
    return returnArray;
}

/**
 *  Creates new cameras for the given structure
 *
 *  @param structure NSDictionary, the structure you want to create cameras for
 *
 *  @return the list of cameras in the structure in an NSArray
 */
- (NSArray *)camerasForStructure:(NSDictionary *)structure {
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < [structure allKeys].count; i++) {
        NSString *structureId = [[structure allKeys] objectAtIndex:i];
        NSArray *camerasIds = [[structure objectForKey:structureId] objectForKey:kCamerasKey];
        
        if (!camerasIds || [camerasIds count] == 0) {
            continue;
        } else {
            for (int i = 0; i < [camerasIds count]; i++) {
                NCCamera *camera = [NCCamera new];
                camera.cameraId = [camerasIds objectAtIndex:i];
                [returnArray addObject:camera];
            }
        }
    }
    
    return returnArray;
}

@end
