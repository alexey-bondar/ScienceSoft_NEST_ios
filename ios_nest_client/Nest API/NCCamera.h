//
//  NCCamera.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCCamera : NSObject

@property (nonatomic, strong) NSString *cameraId;
@property (nonatomic, strong) NSString *nameLong;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *webUrl;
@property (nonatomic, strong) NSString *appUrl;

@end
