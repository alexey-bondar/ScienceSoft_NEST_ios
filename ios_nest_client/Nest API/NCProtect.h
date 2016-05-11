//
//  NCProtect.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NCProtectColorState) {
    NCProtectColorStateGreen,
    NCProtectColorStateYellow,
    NCProtectColorStateRed,
    NCProtectColorStateGrey
};

@interface NCProtect : NSObject

@property (nonatomic, strong) NSString *protectId;
@property (nonatomic, strong) NSString *nameLong;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *batteryHealth;
@property (nonatomic, strong) NSString *coAlarmState;
@property (nonatomic, strong) NSString *smokeAlarmState;
@property (nonatomic, assign) NCProtectColorState uiColorState;
@property (nonatomic, assign) BOOL isOnline;

- (void)updateUIColorState:(NSString *)uiColorState;
- (void)generateUIColorState;

@end
