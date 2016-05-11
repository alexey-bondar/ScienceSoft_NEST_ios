//
//  NCNestAPIManager.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/3/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NCNestAuthAPIProtocol <NSObject>

- (NSString *)authorizationURL;
- (NSString *)accessURL;
- (void)exchangeCodeForTokenWithCompletion:(void(^)(NSError *error))completion;
- (void)logoutWithCompletion:(void(^)(NSError *error))completion;

@end

@interface NCNestAPIManager : NSObject <NCNestAuthAPIProtocol>

+ (instancetype)sharedInstance;

@end
