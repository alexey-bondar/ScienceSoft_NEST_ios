//
//  NCDevicesDataSource.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/4/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

#import "NCDevicesDataSource.h"
#import "NCNestThermostatManager.h"
#import "NCNestProtectManager.h"
#import "NCNestCameraManager.h"
#import "NCNestStructureManager.h"
#import "NCThermostat.h"
#import "NCProtect.h"
#import "NCCamera.h"
#import "NCThermostatStatus.h"
#import "NCProtectStatus.h"
#import "NCThermostatCell.h"
#import "NCProtectCell.h"
#import "NCCameraCell.h"

@interface NCDevicesDataSource () <NCNestProtectManagerDelegate, NCNestCameraManagerDelegate>

@property (nonatomic, strong) NCNestThermostatManager *nestThermostatManager;
@property (nonatomic, strong) NCNestProtectManager *nestProtectManager;
@property (nonatomic, strong) NCNestCameraManager *nestCameraManager;
@property (nonatomic, strong) NCNestStructureManager *nestStructureManager;

@property (nonatomic, strong) NSDictionary *currentStructure;

- (void)_subscribeToThermostat:(NCThermostat *)thermostat;
- (void)_retrieveThermostatsAndSubscribe;
- (void)_subscribeToProtect:(NCProtect *)protect;
- (void)_retrieveProtectsAndSubscribe;
- (void)_subscribeToCamera:(NCCamera *)camera;
- (void)_retrieveCamerasAndSubscribe;

@end

@implementation NCDevicesDataSource

- (instancetype)init {
    if (self = [super init]) {
        _nestStructureManager = [NCNestStructureManager new];
        [_nestStructureManager initialize];
        
        _nestThermostatManager = [NCNestThermostatManager new];
        
        _nestProtectManager = [NCNestProtectManager new];
        [_nestProtectManager setDelegate:self];
        
        _nestCameraManager = [NCNestCameraManager new];
        [_nestCameraManager setDelegate:self];
        
        _thermostats = [NSMutableArray array];
        _protects = [NSMutableArray array];
        _cameras = [NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thermostatValuesChangedNotification:) name:kNCThermostatValueChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(structureUpdatedNotification:) name:kNCStructureUpdatedNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == NCDevicesSectionThermostats) {
        return NSLocalizedString(@"devicesTableView_thermostatsSection_title", nil);
    }
    if (section == NCDevicesSectionProtects) {
        return NSLocalizedString(@"devicesTableView_protectsSection_title", nil);
    }
    if (section == NCDevicesSectionCameras) {
        return NSLocalizedString(@"devicesTableView_camerasSection_title", nil);
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NCDevicesSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == NCDevicesSectionThermostats) {
        return self.thermostats.count;
    }
    if (section == NCDevicesSectionProtects) {
        return self.protects.count;
    }
    if (section == NCDevicesSectionCameras) {
        return self.cameras.count;
    }
    return 0;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.section == NCDevicesSectionThermostats) {
         NCThermostatCell *cell = (NCThermostatCell *)[tableView dequeueReusableCellWithIdentifier:kThermostatCell forIndexPath:indexPath];
         NCThermostat *thermostat = [self.thermostats objectAtIndex:indexPath.row];
         NCThermostatStatus *thermostatStatus = [[NCThermostatStatus alloc] initWithThermostat:thermostat];
         [cell updateWithThermostatStatus:thermostatStatus];
         
         return cell;
     } else if (indexPath.section == NCDevicesSectionProtects) {
         NCProtectCell *cell = (NCProtectCell *)[tableView dequeueReusableCellWithIdentifier:kProtectCell forIndexPath:indexPath];
         NCProtect *protect = [self.protects objectAtIndex:indexPath.row];
         NCProtectStatus *protectStatus = [[NCProtectStatus alloc] initWithProtect:protect];
         [cell updateWithProtectStatus:protectStatus];
         
         return cell;
     } else {
         NCCameraCell *cell = (NCCameraCell *)[tableView dequeueReusableCellWithIdentifier:kCameraCell forIndexPath:indexPath];
         NCCamera *camera = [self.cameras objectAtIndex:indexPath.row];
         [cell updateWithCamera:camera];
         
         return cell;
     }
 }

#pragma mark - Nest thermostat manager notifications

/**
 * Nest thermostat manager notification that lets us know thermostat information has been updated online
 *
 * @param notification NSNotification, notification with the updated thermostat object
 */
- (void)thermostatValuesChangedNotification:(NSNotification *)notification {
    NCThermostat *updatedThermostat = (NCThermostat *)notification.object;
    NSInteger updatedIndex = -1;
    for (int i = 0; i < self.thermostats.count; i++) {
        NCThermostat *thermostat = self.thermostats[i];
        if ([thermostat.thermostatId isEqualToString:updatedThermostat.thermostatId]) {
            updatedIndex = i;
            break;
        }
    }
    
    if (updatedIndex != -1) {
        [self.thermostats replaceObjectAtIndex:updatedIndex withObject:updatedThermostat];
        [self.tableView reloadData];
    }
}

#pragma mark - Nest protect manager delegate

/**
 * Called from NCNestProtectManagerDelegate, lets us know smoke+co alarm information has been updated online
 *
 * @param updatedProtect NCProtect, the updated smoke+co alarm object
 */
- (void)protectValuesChanged:(NCProtect *)updatedProtect {
    NSInteger updatedIndex = -1;
    for (int i = 0; i < self.protects.count; i++) {
        NCProtect *protect = self.protects[i];
        if ([protect.protectId isEqualToString:updatedProtect.protectId]) {
            updatedIndex = i;
            break;
        }
    }
    
    if (updatedIndex != -1) {
        [self.protects replaceObjectAtIndex:updatedIndex withObject:updatedProtect];
        [self.tableView reloadData];
    }
}

#pragma mark - Nest camera manager delegate

/**
 * Called from NCNestCameraManagerDelegate, lets us know camera information has been updated online
 *
 * @param camera NCCamera, the updated camera object
 */
- (void)cameraValuesChanged:(NCCamera *)updatedCamera {
    NSInteger updatedIndex = -1;
    for (int i = 0; i < self.cameras.count; i++) {
        NCCamera *camera = self.cameras[i];
        if ([camera.cameraId isEqualToString:updatedCamera.cameraId]) {
            updatedIndex = i;
            break;
        }
    }
    
    if (updatedIndex != -1) {
        [self.cameras replaceObjectAtIndex:updatedIndex withObject:updatedCamera];
        [self.tableView reloadData];
    }
}

#pragma mark - Nest structure manager notifications

/**
 * Nest structure manager notification that lets us know structure information has been updated online
 *
 * @param notification NSNotification, notification with the updated structure object
 */
- (void)structureUpdatedNotification:(NSNotification *)notificaiton {
    NSDictionary *structure = (NSDictionary *)notificaiton.object;
    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    
    self.currentStructure = structure;
    
    [self _retrieveThermostatsAndSubscribe];
    [self _retrieveProtectsAndSubscribe];
    [self _retrieveCamerasAndSubscribe];
    
    [self.tableView reloadData];
}

#pragma mark - Helpers

/**
 * Setup the communication between data source and thermostat object
 *
 * @param thermostat NCThermostat, the thermostat you wish to subscribe to
 */
- (void)_subscribeToThermostat:(NCThermostat *)thermostat {
    if (thermostat) {
        [self.nestThermostatManager beginSubscriptionForThermostat:thermostat];
    }
}

/**
 *  Retrieves thermostats from the current sctructure and subscribe to all of them
 */
- (void)_retrieveThermostatsAndSubscribe {
    if ([self.currentStructure objectForKey:kThermostatsKey]) {
        [_thermostats removeAllObjects];
        NSUInteger count = [[self.currentStructure objectForKey:kThermostatsKey] count];
        for (int i = 0; i < count; i++) {
            NCThermostat *thermostat = [[self.currentStructure objectForKey:kThermostatsKey] objectAtIndex:i];
            [self _subscribeToThermostat:thermostat];
            [self.thermostats addObject:thermostat];
        }
    }
}

/**
 * Setup the communication between data source and smoke+co alarm object
 *
 * @param protect NCProtect, the smoke+co alarm you wish to subscribe to
 */
- (void)_subscribeToProtect:(NCProtect *)protect {
    if (protect) {
        [self.nestProtectManager beginSubscriptionForProtect:protect];
    }
}

/**
 *  Retrieves smoke+co alarms from the current sctructure and subscribe to all of them
 */
- (void)_retrieveProtectsAndSubscribe {
    if ([self.currentStructure objectForKey:kProtectsKey]) {
        [_protects removeAllObjects];
        NSUInteger count = [[self.currentStructure objectForKey:kProtectsKey] count];
        for (int i = 0; i < count; i++) {
            NCProtect *protect = [[self.currentStructure objectForKey:kProtectsKey] objectAtIndex:i];
            [self _subscribeToProtect:protect];
            [self.protects addObject:protect];
        }
    }
}

/**
 * Setup the communication between data source and camera object
 *
 * @param camera NCCamera, the camera you wish to subscribe to
 */
- (void)_subscribeToCamera:(NCCamera *)camera {
    if (camera) {
        [self.nestCameraManager beginSubscriptionForCamera:camera];
    }
}

/**
 *  Retrieves cameras from the current sctructure and subscribe to all of them
 */
- (void)_retrieveCamerasAndSubscribe {
    if ([self.currentStructure objectForKey:kCamerasKey]) {
        [_cameras removeAllObjects];
        NSUInteger count = [[self.currentStructure objectForKey:kCamerasKey] count];
        for (int i = 0; i < count; i++) {
            NCCamera *camera = [[self.currentStructure objectForKey:kCamerasKey] objectAtIndex:i];
            [self _subscribeToCamera:camera];
            [self.cameras addObject:camera];
        }
    }
}

@end
