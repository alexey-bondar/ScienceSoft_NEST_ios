//
//  NCThermostatDetailsViewController.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCThermostat;

@interface NCThermostatDetailsViewController : UIViewController

@property (nonatomic, strong) NCThermostat *thermostat;

@end
