//
//  NCSession.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/3/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NCSessionWriteProtocol <NSObject>

- (void)setAuthToken:(NSString *)authToken withExpiration:(long)expiration;
- (void)setAuthorizationCode:(NSString *)authorizationCode;

@end

@protocol NCSessionReadProtocol <NSObject>

- (BOOL)isValid;
- (NSString *)authToken;
- (NSString *)authorizationCode;

@end

@interface NCSession : NSObject <NCSessionWriteProtocol, NCSessionReadProtocol>

+ (instancetype)sharedInstance;

@end
