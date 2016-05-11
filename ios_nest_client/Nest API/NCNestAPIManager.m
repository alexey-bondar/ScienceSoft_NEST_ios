//
//  NCNestAPIManager.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/3/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

#import "NCNestAPIManager.h"
#import "NCSession.h"
#import "NCFirebaseManager.h"

@interface NCNestAPIManager ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic, strong) id<NCSessionReadProtocol, NCSessionWriteProtocol> session;
@property (nonatomic, strong) id<NCFirebaseManagerProtocol> firebaseManager;

- (void)_parseAccessTokenWithResponse:(id)responseObject;

@end

@implementation NCNestAPIManager

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NCNestAPIManager new];
    });
    return sharedInstance;
}

- (instancetype)init {
    if (self = [super init]) {
        _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.%@/oauth2/", kNestCurrentAPIDomain]]];
        _sessionManager.requestSerializer.timeoutInterval = kRequestTimeout;
        
        _session = [NCSession sharedInstance];
        _firebaseManager = [NCFirebaseManager sharedInstance];
    }
    return self;
}

#pragma mark - Authentication API

/**
 * Gets the URL to get the authorizationcode
 *
 * @return NSString, the URL to get the authorization code (the login with nest screen)
 */
- (NSString *)authorizationURL {
    return [NSString stringWithFormat:@"https://%@/login/oauth2?client_id=%@&state=%@", kNestCurrentAPIDomain, kNestClientId, kNestState];
}

/**
 *  Gets the URL to get the access key
 *
 *  @return NSString, the URL to get the access token from Nest
 */
- (NSString *)accessURL {
    NSString *authorizationCode = [self.session authorizationCode];
    if (authorizationCode) {
        return [NSString stringWithFormat:@"%@access_token?code=%@&client_id=%@&client_secret=%@&grant_type=authorization_code", self.sessionManager.baseURL.absoluteString, authorizationCode, kNestClientId, kNestClientSecret];
    } else {
        DDLogInfo(@"Missing authorization code");
        return nil;
    }
}

/**
 * Gets the URL for removing access key
 *
 * @return NSString, the URL for removing access token from Nest
 */
- (NSString *)deleteURL {
    return [NSString stringWithFormat:@"access_tokens/%@", [self.session authToken]];
}

/**
 * Exchanges the authorization code for an access token.
 */
- (void)exchangeCodeForTokenWithCompletion:(void(^)(NSError *error))completion {
    DDLogInfo(@"Request for token was started");
    __weak typeof(self) welf = self;
    [self.sessionManager POST:[self accessURL]
                   parameters:nil
                     progress:nil
                      success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                          [welf _parseAccessTokenWithResponse:responseObject];
                          DDLogInfo(@"Request for token was finished with response: %@", responseObject);
                          completion(nil);
                      }
                      failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                          DDLogError(@"Request for token was failed with an error: %@", error);
                          completion(error);
                      }];
}

/**
 *  Initiates a logout request
 *
 *  @param completion, block of code executed whether request is failed or not
 */
- (void)logoutWithCompletion:(void(^)(NSError *error))completion {
    DDLogInfo(@"Logout request was started");
    __weak typeof(self) welf = self;
    [self.sessionManager DELETE:[self deleteURL]
                     parameters:nil
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            DDLogInfo(@"Logout request was finished");
                            [welf.firebaseManager removeObservers];
                            [welf.session setAuthToken:nil withExpiration:0];
                            completion(nil);
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            DDLogInfo(@"Logout request was failed with an error: %@", error);
                            completion(error);
                        }];
}

#pragma mark - Response parser

/**
 *  Parses response object with the access token and stores it
 *
 *  @param responseObject id, response object with the access token
 */
- (void)_parseAccessTokenWithResponse:(id)responseObject {
    NSString *authToken = [responseObject objectForKey:kAuthTokenKey];
    long expiration = [[responseObject objectForKey:kExpiresInKey] longValue];
    [self.session setAuthToken:authToken withExpiration:expiration];
    
    [self.firebaseManager authWithCustomToken];
}

@end
