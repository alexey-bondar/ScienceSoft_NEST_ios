//
//  NCDevicesTableViewController.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/4/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

#import "NCDevicesTableViewController.h"
#import "NCDevicesDataSource.h"
#import "NCThermostat.h"
#import "NCCamera.h"
#import "NCThermostatDetailsViewController.h"
#import "NCCameraDetailsViewController.h"
#import "UIButton+CustomButton.h"
#import "NCNestAPIManager.h"

@interface NCDevicesTableViewController ()

@property (nonatomic, strong) NCDevicesDataSource *dataSource;
@property (nonatomic, strong) id<NCNestAuthAPIProtocol> apiManager;

- (void)_configureNavigationBar;
- (UIButton *)_configureLogoutButton;

@end

@implementation NCDevicesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.dataSource = [NCDevicesDataSource new];
    self.dataSource.tableView = self.tableView;
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self;
    
    _apiManager = [NCNestAPIManager sharedInstance];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NCThermostatCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:kThermostatCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"NCProtectCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:kProtectCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"NCCameraCell" bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:kCameraCell];
    self.tableView.separatorColor = [UIColor clearColor];
    
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    
    [self _configureNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configure views

/**
 *  Provides configuration for navigation bar
 */
- (void)_configureNavigationBar {
    [self.navigationItem setTitle:NSLocalizedString(@"devicesTableView_navigationTitle", nil)];
    
    UIBarButtonItem *logutButton = [[UIBarButtonItem alloc] initWithCustomView:[self _configureLogoutButton]];
    self.navigationItem.leftBarButtonItem = logutButton;
}

/**
 *  Provides configuration for logout button
 *
 *  @return UIButton, instance of UIButton class
 */
- (UIButton *)_configureLogoutButton {
    UIButton *button = [UIButton nc_buttonForNavigationBar];
    [button setTitle:NSLocalizedString(@"devicesTableView_navigation_logoutTitle", nil) forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(logoutButtonWasPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == NCDevicesSectionCameras) {
        NCCamera *camera = [self.dataSource.cameras objectAtIndex:indexPath.row];
        
        NCCameraDetailsViewController *cameraDetailsViewController = [NCCameraDetailsViewController new];
        cameraDetailsViewController.camera = camera;
        [self.navigationController pushViewController:cameraDetailsViewController animated:YES];
    } else if (indexPath.section == NCDevicesSectionThermostats) {
        NCThermostat *thermostat = [self.dataSource.thermostats objectAtIndex:indexPath.row];
        
        NCThermostatDetailsViewController *thermostatDetailsViewController = [NCThermostatDetailsViewController new];
        thermostatDetailsViewController.thermostat = thermostat;
        [self.navigationController pushViewController:thermostatDetailsViewController animated:YES];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - User's actions

/**
 *  Instantiates logout request when user taps on logout button
 *
 *  @param sender id, logout button
 */
- (void)logoutButtonWasPressed:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
    __weak typeof(self) welf = self;
    [self.apiManager logoutWithCompletion:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        [welf dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
