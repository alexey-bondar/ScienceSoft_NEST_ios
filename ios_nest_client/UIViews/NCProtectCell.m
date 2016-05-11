//
//  NCProtectCell.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "NCProtectCell.h"
#import "NCProtectStatus.h"
#import "UIColor+CustomColors.h"

@interface NCProtectCell ()

@property (weak, nonatomic) IBOutlet UILabel *protectTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *uiColorStateImageView;
@property (weak, nonatomic) IBOutlet UILabel *coAlarmLabel;
@property (weak, nonatomic) IBOutlet UILabel *smokeAlarmLabel;
@property (weak, nonatomic) IBOutlet UILabel *batteryAlarmLabel;

- (void)_updateUIColorStateWithProtectStatus:(NCProtectStatus *)status;

@end

@implementation NCProtectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.uiColorStateImageView.image = [self.uiColorStateImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.coAlarmLabel.text = NSLocalizedString(@"protectCell_coLabel_text", nil);
    self.smokeAlarmLabel.text = NSLocalizedString(@"protectCell_smokeLabel_text", nil);
    self.batteryAlarmLabel.text = NSLocalizedString(@"protectCell_batteryLabel_text", nil);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Configure UI

/**
 *  Updates the smoke+co alarm cell according to the current status
 *
 *  @param status NCProtectStatus, calculated status of the smoke+co alarm
 */
- (void)updateWithProtectStatus:(NCProtectStatus *)status {
    self.protectTitleLabel.text = status.title;
    
    [self _updateUIColorStateWithProtectStatus:status];
    
    self.coAlarmLabel.textColor = [status coAlarmStateColor];
    self.smokeAlarmLabel.textColor = [status smokeAlarmStateColor];
    self.batteryAlarmLabel.textColor = [status batteryAlarmStateColor];
}

/**
 *  Updates UI color state image view according to the current smoke+co alarm status
 *
 *  @param status NCProtectStatus, calculated status of the smoke+co alarm
 */
- (void)_updateUIColorStateWithProtectStatus:(NCProtectStatus *)status {
    switch (status.uiColorState) {
        case NCProtectColorStateGreen:
            [self.uiColorStateImageView setTintColor:[UIColor nc_greenSmokeCOAlarmColor]];
            break;
        case NCProtectColorStateYellow:
            [self.uiColorStateImageView setTintColor:[UIColor nc_yellowSmokeCOAlarmColor]];
            break;
        case NCProtectColorStateRed:
            [self.uiColorStateImageView setTintColor:[UIColor nc_redSmokeCOAlarmColor]];
            break;
        case NCProtectColorStateGrey:
            [self.uiColorStateImageView setTintColor:[UIColor nc_greySmokeCOAlarmColor]];
            break;
    }
}

@end
