//
//  UICameraDetailsViewController.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/5/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//
@import MediaPlayer;

#import <MBProgressHUD/MBProgressHUD.h>

#import "NCCameraDetailsViewController.h"
#import "NCCamera.h"

@interface NCCameraDetailsViewController ()

@property (nonatomic, strong) MPMoviePlayerController *player;

@end

@implementation NCCameraDetailsViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:self.camera.nameLong];

    self.player = [[MPMoviePlayerController alloc] initWithContentURL: [NSURL URLWithString:self.camera.webUrl]];
    self.player.shouldAutoplay = YES;
    [self.player prepareToPlay];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerDidExitFullscreenNotification:) name:MPMoviePlayerDidExitFullscreenNotification object:self.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(structureUpdatedNotification:) name:kNCStructureUpdatedNotification object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    if ([self.player.view superview] == nil) {
        [self.player.view setFrame: self.view.bounds];
        self.player.view.center = self.view.center;
        [self.view addSubview: self.player.view];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.player play];
    [self.player setFullscreen:YES animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moviePlayerDidExitFullscreenNotification:(NSNotification *)notification {
    [self.player stop];
    [self.navigationController popViewControllerAnimated:YES];
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
    if ([structure objectForKey:kCamerasKey]) {
        NSUInteger count = [[structure objectForKey:kCamerasKey] count];
        for (int i = 0; i < count; i++) {
            NCCamera *camera = [[structure objectForKey:kCamerasKey] objectAtIndex:i];
            if ([camera.cameraId isEqualToString:self.camera.cameraId]) {
                isDeleted = NO;
                break;
            }
        }
    }
    if (isDeleted) {
        [self.player stop];
        [self.player.view removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
