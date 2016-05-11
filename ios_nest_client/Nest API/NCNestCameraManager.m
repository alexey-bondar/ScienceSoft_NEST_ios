//
//  NCNestCameraManager.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "NCNestCameraManager.h"
#import "NCFirebaseManager.h"
#import "NCCamera.h"

@interface NCNestCameraManager ()

@property (nonatomic, strong) id<NCFirebaseManagerProtocol> firebaseManager;

@end


@implementation NCNestCameraManager

- (instancetype)init {
    if (self = [super init]) {
        _firebaseManager = [NCFirebaseManager sharedInstance];
    }
    return self;
}

/**
 *  Sets up a new Firebase connection for the camera provided and observes for any change in /devices/cameras/cameraId
 *
 *  @param protect NCCamera, the camera you want to watch changes for
 */
- (void)beginSubscriptionForCamera:(NCCamera *)camera {
    __weak typeof(self) welf = self;
    [self.firebaseManager addSubscriptionToURL:[NSString stringWithFormat:@"%@/%@/", kCameraPath, camera.cameraId] withBlock:^(FDataSnapshot *snapshot) {
        DDLogInfo(@"Values for URL: %@ were updated", [NSString stringWithFormat:@"%@/%@/", kCameraPath, camera.cameraId]);
        [welf updateCamera:camera forStructure:snapshot.value];
    }];
}

/**
 *  Parse camera structure and put it in the camera object. Then send the updated object with notification.
 *
 *  @param camera NCCamera, the camera you wish to update
 *  @param structure  NSDictionary, he structure you wish to update the camera with
 */
- (void)updateCamera:(NCCamera *)camera forStructure:(NSDictionary *)structure {
    if ([structure objectForKey:kNameLong]) {
        camera.nameLong = [structure objectForKey:kNameLong];
    }
    if ([structure objectForKey:kName]) {
        camera.name = [structure objectForKey:kName];
    }
    if ([structure objectForKey:kLastEvent] &&
        [[structure objectForKey:kLastEvent] objectForKey:kAppUrl]) {
        camera.appUrl = [[structure objectForKey:kLastEvent] objectForKey:kAppUrl];
    } else {
        camera.appUrl = [structure objectForKey:kAppUrl];
    }
    if ([structure objectForKey:kLastEvent] &&
        [[structure objectForKey:kLastEvent] objectForKey:kWebUrl]) {
        camera.webUrl = [[structure objectForKey:kLastEvent] objectForKey:kWebUrl];
    } else {
        camera.webUrl = [structure objectForKey:kWebUrl];
    }
    
    [self.delegate cameraValuesChanged:camera];
}

@end
