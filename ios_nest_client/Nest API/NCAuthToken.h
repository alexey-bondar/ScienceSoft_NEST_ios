//
//  NCAuthToken.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/4/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCAuthToken : NSObject

@property (nonatomic, strong) NSString *token;

- (BOOL)isValid;

+ (NCAuthToken *)tokenWithToken:(NSString *)token expiresIn:(long)expiration;

@end
