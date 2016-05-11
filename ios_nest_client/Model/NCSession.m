//
//  NCSession.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/3/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "NCSession.h"
#import "NCAuthToken.h"

@implementation NCSession

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NCSession new];
    });
    return sharedInstance;
}

#pragma mark - Session read protocol

/**
 *  Checks whether the current session is authenticated
 *
 *  @return BOOL, YES if session is valid, otherwise NO
 */
- (BOOL)isValid {
    if ([self authToken]) {
        return true;
    } else {
        return false;
    }
}

/**
 *  Provides the access token
 *
 *  @return NSString, access token for the current session
 */
- (NSString *)authToken {
    NSData *encodedObject = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthTokenKey];
    
    // If there is nothing there -- return
    if (!encodedObject) {
        return nil;
    }
    NCAuthToken *authToken = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return [authToken isValid] ? authToken.token : nil;
}

/**
 *  Provides the authrization code
 *
 *  @return NSString, authorization code
 */
- (NSString *)authorizationCode {
    NSString *authorizationCode = [[NSUserDefaults standardUserDefaults] objectForKey:kAuthCodeKey];
    return authorizationCode;
}

#pragma mark - Session write protocol

/**
 *  Stores the access token to NSUserDefaults if it's not nil, otherwise remove the old one
 *
 *  @param authToken  NSString, access token
 *  @param expiration long, expiration of the token
 */
- (void)setAuthToken:(NSString *)authToken withExpiration:(long)expiration {
    if (authToken) {
        NCAuthToken *nat = [NCAuthToken tokenWithToken:authToken expiresIn:expiration];
        NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:nat];
        [[NSUserDefaults standardUserDefaults] setObject:encodedObject forKey:kAuthTokenKey];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAuthTokenKey];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  Stores the authorizationCode to NSUserDefaults
 *
 *  @param authorizationCode NSString, authorization code
 */
- (void)setAuthorizationCode:(NSString *)authorizationCode {
    [[NSUserDefaults standardUserDefaults] setObject:authorizationCode forKey:kAuthCodeKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
