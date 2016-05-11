//
//  NCNestCameraManager.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NCCamera;

@protocol NCNestCameraManagerDelegate <NSObject>

- (void)cameraValuesChanged:(NCCamera *)updatedCamera;

@end

@interface NCNestCameraManager : NSObject

@property (nonatomic, strong) id <NCNestCameraManagerDelegate>delegate;

- (void)beginSubscriptionForCamera:(NCCamera *)camera;

@end
