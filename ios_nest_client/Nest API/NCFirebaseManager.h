//
//  NCFirebaseManager.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/4/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>

typedef void (^ SubscriptionBlock)(FDataSnapshot *snapshot);

@protocol NCFirebaseManagerProtocol <NSObject>

- (void)addSubscriptionToURL:(NSString *)URL withBlock:(SubscriptionBlock)block;
- (void)setValues:(NSDictionary *)values forURL:(NSString *)URL;
- (void)authWithCustomToken;
- (void)removeObservers;

@end

@interface NCFirebaseManager : NSObject <NCFirebaseManagerProtocol>

+ (instancetype)sharedInstance;

@end
