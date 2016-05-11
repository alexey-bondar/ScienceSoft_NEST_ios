//
//  NCThermostatCell.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/4/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCThermostatStatus;

@interface NCThermostatCell : UITableViewCell

- (void)updateWithThermostatStatus:(NCThermostatStatus *)status;

@end
