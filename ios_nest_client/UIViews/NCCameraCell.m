//
//  NCCameraCell.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import "NCCameraCell.h"
#import "NCCamera.h"

@interface NCCameraCell ()

@property (weak, nonatomic) IBOutlet UILabel *cameraTitleLabel;

@end

@implementation NCCameraCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Configure UI

/**
 *  Updates the camera cell according to the current state
 *
 *  @param status NCCamera, camera's object
 */
- (void)updateWithCamera:(NCCamera *)camera {
    self.cameraTitleLabel.text = camera.nameLong;
}

@end
