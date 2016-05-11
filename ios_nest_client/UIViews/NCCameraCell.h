//
//  NCCameraCell.h
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NCCamera;

@interface NCCameraCell : UITableViewCell

- (void)updateWithCamera:(NCCamera *)camera;

@end
