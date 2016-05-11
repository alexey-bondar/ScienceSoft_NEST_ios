//
//  NCNestProtectManager.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "NCNestProtectManager.h"
#import "NCFirebaseManager.h"
#import "NCProtect.h"

@interface NCNestProtectManager ()

@property (nonatomic, strong) id<NCFirebaseManagerProtocol> firebaseManager;

@end

@implementation NCNestProtectManager

- (instancetype)init {
    if (self = [super init]) {
        _firebaseManager = [NCFirebaseManager sharedInstance];
    }
    return self;
}

/**
 *  Sets up a new Firebase connection for the smoke+co alarm provided and observes for any change in /devices/smoke_co_alarms/smoke_co_alarmId
 *
 *  @param protect NCProtect, the smoke+co alarm you want to watch changes for
 */
- (void)beginSubscriptionForProtect:(NCProtect *)protect {
    __weak typeof(self) welf = self;
    [self.firebaseManager addSubscriptionToURL:[NSString stringWithFormat:@"%@/%@/", kProtectPath, protect.protectId] withBlock:^(FDataSnapshot *snapshot) {
        DDLogInfo(@"Values for URL: %@ were updated", [NSString stringWithFormat:@"%@/%@/", kProtectPath, protect.protectId]);
        [welf updateProtect:protect forStructure:snapshot.value];
    }];
}

/**
 *  Parse smoke+co alarm structure and put it in the smoke+co alarm object. Then send the updated object with notification.
 *
 *  @param protect NCProtect, the smoke+co alarm you wish to update
 *  @param structure  NSDictionary, he structure you wish to update the smoke+co alarm with
 */
- (void)updateProtect:(NCProtect *)protect forStructure:(NSDictionary *)structure {
    if ([structure objectForKey:kNameLong]) {
        protect.nameLong = [structure objectForKey:kNameLong];
    }
    if ([structure objectForKey:kName]) {
        protect.name = [structure objectForKey:kName];
    }
    if ([structure objectForKey:kBatteryHealth]) {
        protect.batteryHealth = [structure objectForKey:kBatteryHealth];
    }
    if ([structure objectForKey:kCOAlarmState]) {
        protect.coAlarmState = [structure objectForKey:kCOAlarmState];
    }
    if ([structure objectForKey:kSmokeAlarmState]) {
        protect.smokeAlarmState = [structure objectForKey:kSmokeAlarmState];
    }
    if ([structure objectForKey:kIsOnline]) {
        protect.isOnline = [[structure objectForKey:kIsOnline] boolValue];
    }
    if ([structure objectForKey:kUIColorState]) {
        [protect updateUIColorState:[structure objectForKey:kUIColorState]];
    } else {
        [protect generateUIColorState];
    }
    
    [self.delegate protectValuesChanged:protect];
}

@end
