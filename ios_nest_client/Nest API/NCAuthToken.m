//
//  NCAuthToken.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/4/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "NCAuthToken.h"

@interface NCAuthToken () <NSCoding>

@property (nonatomic, strong) NSDate *expiresOn;

@end

@implementation NCAuthToken

/**
 * Tells whether or not the token is valid
 *
 * @return BOOL, YES if valid token, otherwise NO
 */
- (BOOL)isValid {
    if (self.token){
        if ([[NSDate date] compare:self.expiresOn] == NSOrderedAscending) {
            return YES;
        }
    }
    
    return NO;
}

/**
 * Sets the token and expiration date
 *
 * @param token NSString, the token string
 * @param expiration long, the amount of time (in seconds) the token has until it expires
 * @return NCAuthToken, access token object
 */
+ (NCAuthToken *)tokenWithToken:(NSString *)token expiresIn:(long)expiration {
    NCAuthToken *authToken = [NCAuthToken new];
    authToken.token = token;
    authToken.expiresOn = [[NSDate date] dateByAddingTimeInterval:expiration];
    return authToken;
}

/**
 * Encode the access token.
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.token forKey:kTokenKey];
    [encoder encodeObject:self.expiresOn forKey:kExpiresInKey];
}

/**
 * Decode the access token.
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.token = [decoder decodeObjectForKey:kTokenKey];
        self.expiresOn = [decoder decodeObjectForKey:kExpiresInKey];
    }
    return self;
}

@end
