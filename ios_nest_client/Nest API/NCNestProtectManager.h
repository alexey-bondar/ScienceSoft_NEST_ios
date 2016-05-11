//
//  NCNestProtectManager.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NCProtect;

@protocol NCNestProtectManagerDelegate <NSObject>

- (void)protectValuesChanged:(NCProtect *)updatedProtect;

@end

@interface NCNestProtectManager : NSObject

@property (nonatomic, strong) id <NCNestProtectManagerDelegate>delegate;

- (void)beginSubscriptionForProtect:(NCProtect *)protect;

@end
