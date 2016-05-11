//
//  NCDevicesDataSource.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/4/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, NCDevicesSection) {
    NCDevicesSectionThermostats,
    NCDevicesSectionProtects,
    NCDevicesSectionCameras,
    NCDevicesSections
};

@interface NCDevicesDataSource : NSObject <UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *thermostats;
@property (nonatomic, strong) NSMutableArray *protects;
@property (nonatomic, strong) NSMutableArray *cameras;

@end
