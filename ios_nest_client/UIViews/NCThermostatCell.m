//
//  NCThermostatCell.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/4/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "NCThermostatCell.h"
#import "NCThermostatStatus.h"
#import "UIColor+CustomColors.h"

@interface NCThermostatCell ()

@property (weak, nonatomic) IBOutlet UILabel *thermostatTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetTemperatureTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *fanImageView;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heatingModeImageView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureScaleLabel;

- (void)_updateFanModeWithStatus:(NCThermostatStatus *)status;
- (void)_updateHeatingModeWithStatus:(NCThermostatStatus *)status;
- (void)_updateTemperatureWithStatus:(NCThermostatStatus *)status;

@end

@implementation NCThermostatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.heatingModeImageView.image = [self.heatingModeImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.humidityTextLabel.text = NSLocalizedString(@"thermostatCell_humidityText", nil);
    self.targetTemperatureTextLabel.text = NSLocalizedString(@"thermostatCell_targetTemperatureText", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Configure UI

/**
 *  Updates the thermostat cell according to the current thermostat status
 *
 *  @param status NCThermostatStatus, calculated status of the thermostat
 */
- (void)updateWithThermostatStatus:(NCThermostatStatus *)status {
    self.thermostatTitleLabel.text = status.title;
    
    [self _updateFanModeWithStatus:status];
    [self _updateHeatingModeWithStatus:status];
    [self _updateTemperatureWithStatus:status];
    
    self.humidityLabel.text = status.humidity;
}

/**
 *  Updates fan image view according to the current thermostat status
 *
 *  @param status NCThermostatStatus, calculated status of the thermostat
 */
- (void)_updateFanModeWithStatus:(NCThermostatStatus *)status {
    switch (status.fanMode) {
        case NCThermostatFanModeFan:
            self.fanImageView.image = [UIImage imageNamed:@"fan"];
            break;
        case NCThermostatFanModeLeaf:
            self.fanImageView.image = [UIImage imageNamed:@"leaf"];
            break;
        case NCThermostatFanModeOff:
            self.fanImageView.image = [UIImage new];
            break;
    }
}

/**
 *  Updates heating image view according to the current thermostat status
 *
 *  @param status NCThermostatStatus, calculated status of the thermostat
 */
- (void)_updateHeatingModeWithStatus:(NCThermostatStatus *)status {
    switch (status.heatingMode) {
        case NCThermostatModeHeating:
            [self.heatingModeImageView setTintColor:[UIColor nc_heatingThermostatColor]];
            break;
        case NCThermostatModeCooling:
            [self.heatingModeImageView setTintColor:[UIColor nc_coolingThermostatColor]];
            break;
        case NCThermostatModeNeutral:
            [self.heatingModeImageView setTintColor:[UIColor nc_neutralThermostatColor]];
            break;
    }
}

/**
 *  Updates target and current temperature labels according to the current thermostat status
 *
 *  @param status NCThermostatStatus, calculated status of the thermostat
 */
- (void)_updateTemperatureWithStatus:(NCThermostatStatus *)status {
    self.currentTemperatureLabel.text = status.targetTemperature;
    self.targetTemperatureLabel.text = status.currentTemperature;
    
    if (status.temperatureScale != nil) {
        self.temperatureScaleLabel.text = [NSString stringWithFormat:@"°%@", status.temperatureScale];
    } else {
        self.temperatureScaleLabel.text = @"";
    }
}

@end
