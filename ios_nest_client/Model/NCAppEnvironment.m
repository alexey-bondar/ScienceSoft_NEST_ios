//
//  NSAppEnvironment.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/3/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>

#import "NCAppEnvironment.h"

@interface NCAppEnvironment ()

- (void)_configureFileLogger;

@end

@implementation NCAppEnvironment

- (void)setupAppEnvironment {
    [self _configureFileLogger];
}

#pragma mark - Logger

/**
 *  Provides the configuration of the file logger
 */
- (void)_configureFileLogger {
    [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
    [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    
    DDFileLogger *fileLogger = [[DDFileLogger alloc] init]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
    [DDLog addLogger:fileLogger];
}

@end
