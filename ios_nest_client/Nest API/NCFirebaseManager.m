//
//  NCFirebaseManager.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/4/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "NCFirebaseManager.h"
#import "NCSession.h"

@interface NCFirebaseManager ()

@property (nonatomic, strong) NSMutableDictionary *subscribedURLs;
@property (nonatomic, strong) NSMutableDictionary *fireBi; // The plural of Firebase

@property (nonatomic, strong) Firebase *rootFirebase;

@property (nonatomic, strong) id<NCSessionReadProtocol> session;

@end

@implementation NCFirebaseManager

/**
 *  Creates or retrieves the shared Firebase manager
 *
 *  @return the singleton shared Firebase manager
 */
+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [NCFirebaseManager new];
    });
    
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        _session = [NCSession sharedInstance];
        _subscribedURLs = [[NSMutableDictionary alloc] init];
        _fireBi = [[NSMutableDictionary alloc] init];
        _rootFirebase = [[Firebase alloc] initWithUrl:@"https://developer-api.nest.com/"];
        
        [self authWithCustomToken];
    }
    
    return self;
}

/**
 *  Instantiates Firebase auth request with the current access token
 */
- (void)authWithCustomToken {
    DDLogInfo(@"Firebase authentication was started");
    if ([self.session isValid]) {
        [_rootFirebase authWithCustomToken:[_session authToken] withCompletionBlock:^(NSError *error, FAuthData *authData) {
            DDLogInfo(@"Firebase authentication finished with auth data: %@, error: %@", authData, error);
        }];
    }
}

/**
 *  Cleans up all observers from firebase
 */
- (void)removeObservers {
    DDLogInfo(@"Removing firebase observers was started");
    [self.fireBi enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        Firebase *firebase = (Firebase *)obj;
        [firebase removeAllObservers];
        [self.subscribedURLs removeObjectForKey:key];
        DDLogInfo(@"Firebase observer for URL: %@ was removed", key);
    }];
    
    [self.fireBi removeAllObjects];
    DDLogInfo(@"Removing firebase observers was finished");
}

/**
 *  Adds a subscription to the URL and creates a new firebase for that subscription
 *
 *  @param URL   the URL you wish to subscribe to
 *  @param block the block you want to execute when values change at the specified firebase location
 */
- (void)addSubscriptionToURL:(NSString *)URL withBlock:(SubscriptionBlock)block {
    DDLogInfo(@"Add firebase subscription to URL: %@", URL);
    if ([self.subscribedURLs objectForKey:URL]) {
        block([self.subscribedURLs objectForKey:URL]);
        DDLogInfo(@"Firebase has already subscribed to URL: %@", URL);
    } else {
        Firebase *newFirebase = [self.rootFirebase childByAppendingPath:URL];
        
        __weak typeof(self) welf = self;
        [newFirebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
            [welf.subscribedURLs setObject:snapshot forKey:URL];
            block(snapshot);
        }];
        
        [self.fireBi setObject:newFirebase forKey:URL];
        DDLogInfo(@"Firebase observer for URL: %@ was added", URL);
    }
}

/**
 *  Sets the values for the given firebase URL
 *
 *  @param values the key value pairs you want to update
 *  @param URL    the URL you want to update to
 */
- (void)setValues:(NSDictionary *)values forURL:(NSString *)URL {
    DDLogInfo(@"Begin values update for URL: %@", URL);
    if ([self.subscribedURLs objectForKey:URL]) {
        [[self.fireBi objectForKey:URL]  runTransactionBlock:^FTransactionResult *(FMutableData *currentData) {
            [currentData setValue:values];
            return [FTransactionResult successWithValue:currentData];
        } andCompletionBlock:^(NSError *error, BOOL committed, FDataSnapshot *snapshot) {
            if (error) {
                DDLogError(@"Setting values was failed with an error: %@", error);
            } else {
                DDLogInfo(@"Values were set successfully");
            }
        } withLocalEvents:NO];
    }
}

@end
