//
//  NCThermostatDetailsViewController.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "NCThermostatDetailsViewController.h"
#import "NCNestThermostatManager.h"
#import "NCThermostat.h"
#import "UIColor+CustomColors.h"
#import "NCThermostatStatus.h"
#import "NCFirebaseManager.h"

@interface NCThermostatDetailsViewController ()

@property (weak, nonatomic) IBOutlet UISlider *targetTemperatureSlider;
@property (weak, nonatomic) IBOutlet UILabel *temperatureScaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *targetTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *heatingModeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *fanModeImageView;

@property (nonatomic, strong) id<NCFirebaseManagerProtocol> firebaseManager;

- (void)_updateWithThermostatStatus:(NCThermostatStatus *)status;
- (void)_updateFanModeWithThermostatStatus:(NCThermostatStatus *)status;
- (void)_updateHeatingModeWithThermostatStatus:(NCThermostatStatus *)status;
- (void)_updateTemperatureWithThermostatStatus:(NCThermostatStatus *)status;
- (void)_updateTemperatureSliderWithThermostatStatus:(NCThermostatStatus *)status;

@end

@implementation NCThermostatDetailsViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _firebaseManager = [NCFirebaseManager sharedInstance];
    
    CGAffineTransform trans = CGAffineTransformMakeRotation(-M_PI_2);
    self.targetTemperatureSlider.transform = trans;
    self.targetTemperatureSlider.minimumTrackTintColor = [UIColor nc_heatingThermostatColor];
    self.targetTemperatureSlider.maximumTrackTintColor = [UIColor nc_coolingThermostatColor];
    
    self.humidityTextLabel.text = NSLocalizedString(@"thermostatCell_humidityText", nil);
    self.currentTemperatureTextLabel.text = NSLocalizedString(@"thermostatCell_currentTemperatureShortText", nil);
    self.heatingModeImageView.image = [self.heatingModeImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thermostatValuesChangedNotification:) name:kNCThermostatValueChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(structureUpdatedNotification:) name:kNCStructureUpdatedNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NCThermostatStatus *status = [[NCThermostatStatus alloc] initWithThermostat:self.thermostat];
    [self _updateWithThermostatStatus:status];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setThermostat:(NCThermostat *)thermostat {
    _thermostat = thermostat;
    NCThermostatStatus *status = [[NCThermostatStatus alloc] initWithThermostat:self.thermostat];
    
    [self _updateWithThermostatStatus:status];
}

#pragma mark - Nest thermostat manager notifications

/**
 * Nest thermostat manager notification that lets us know thermostat information has been updated online
 *
 * @param notification NSNotification, notification with the updated thermostat object
 */
- (void)thermostatValuesChangedNotification:(NSNotification *)notification {
    NCThermostat *updatedThermostat = (NCThermostat *)notification.object;
    if ([self.thermostat.thermostatId isEqualToString:updatedThermostat.thermostatId]) {
        self.thermostat = updatedThermostat;
    }
}

#pragma mark - Nest structure manager notifications

/**
 * Nest structure manager notification that lets us know structure information has been updated online
 *
 * @param notification NSNotification, notification with the updated structure object
 */
- (void)structureUpdatedNotification:(NSNotification *)notificaiton {
    NSDictionary *structure = (NSDictionary *)notificaiton.object;
    
    BOOL isDeleted = YES;
    if ([structure objectForKey:kThermostatsKey]) {
        NSUInteger count = [[structure objectForKey:kThermostatsKey] count];
        for (int i = 0; i < count; i++) {
            NCThermostat *thermostat = [[structure objectForKey:kThermostatsKey] objectAtIndex:i];
            if ([thermostat.thermostatId isEqualToString:self.thermostat.thermostatId]) {
                isDeleted = NO;
                break;
            }
        }
    }
    if (isDeleted) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Update UI

/**
 *  Updates thermostat view according to the state of the thermostat status object
 *
 *  @param status NCThermostatStatus, state of the thermostat status object
 */
- (void)_updateWithThermostatStatus:(NCThermostatStatus *)status {
    [self.navigationItem setTitle:status.title];
    
    [self _updateFanModeWithThermostatStatus:status];
    [self _updateHeatingModeWithThermostatStatus:status];
    [self _updateTemperatureWithThermostatStatus:status];
    
    self.humidityLabel.text = status.humidity;
    
    [self _updateTemperatureSliderWithThermostatStatus:status];
}

- (void)_updateFanModeWithThermostatStatus:(NCThermostatStatus *)status {
    switch (status.fanMode) {
        case NCThermostatFanModeFan:
            self.fanModeImageView.image = [UIImage imageNamed:@"fan"];
            break;
        case NCThermostatFanModeLeaf:
            self.fanModeImageView.image = [UIImage imageNamed:@"leaf"];
            break;
        case NCThermostatFanModeOff:
            self.fanModeImageView.image = [UIImage new];
            break;
    }
}

- (void)_updateHeatingModeWithThermostatStatus:(NCThermostatStatus *)status {
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

- (void)_updateTemperatureWithThermostatStatus:(NCThermostatStatus *)status {
    self.currentTemperatureLabel.text = status.currentTemperature;
    self.targetTemperatureLabel.text = status.targetTemperature;
    
    if (status.temperatureScale != nil) {
        self.temperatureScaleLabel.text = [NSString stringWithFormat:@"°%@", status.temperatureScale];
    } else {
        self.temperatureScaleLabel.text = @"";
    }
}

- (void)_updateTemperatureSliderWithThermostatStatus:(NCThermostatStatus *)status {
    if (self.thermostat.hvacMode == NCThermostatHvacModeHeatCool ||
        self.thermostat.hvacMode == NCThermostatHvacModeOff) {
        self.targetTemperatureSlider.enabled = NO;
    } else {
        self.targetTemperatureSlider.enabled = YES;
    }
    
    self.targetTemperatureSlider.minimumValue = self.thermostat.temperatureScaleType == NCThermostatTemperatureScaleC ? kThermostatMinC : kThermostatMinF;
    self.targetTemperatureSlider.maximumValue = self.thermostat.temperatureScaleType == NCThermostatTemperatureScaleC ? kThermostatMaxC : kThermostatMaxF;
    self.targetTemperatureSlider.value = self.thermostat.temperatureScaleType == NCThermostatTemperatureScaleC ? self.thermostat.targetTemperatureC : self.thermostat.targetTemperatureF;
}

#pragma mark - User's actions

- (IBAction)targetTemperatureChanged:(id)sender {
    if (self.thermostat.temperatureScaleType == NCThermostatTemperatureScaleF) {
        self.thermostat.targetTemperatureF = self.targetTemperatureSlider.value;
    } else {
        self.thermostat.targetTemperatureC = self.targetTemperatureSlider.value;
    }
    
    self.targetTemperatureLabel.text = [NSString stringWithFormat:@"%.0f", self.targetTemperatureSlider.value];
}

- (IBAction)targetTemperatureTouchUpInside:(id)sender {
    NSMutableDictionary *values = [[NSMutableDictionary alloc] init];
    
    if (self.thermostat.temperatureScaleType == NCThermostatTemperatureScaleF) {
        [values setValue:[NSNumber numberWithInteger:self.thermostat.targetTemperatureF] forKey:kTargetTemperatureF];
    } else {
        [values setValue:[NSNumber numberWithInteger:self.thermostat.targetTemperatureC] forKey:kTargetTemperatureC];
    }
    
    [self.firebaseManager setValues:values forURL:[NSString stringWithFormat:@"%@/%@/", kThermostatPath, self.thermostat.thermostatId]];
}

@end
