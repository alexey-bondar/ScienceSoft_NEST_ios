//
//  NCAuthenticationViewController.m
//  ios_nest_client
//
//  Created by Bondar, Alexey on 5/3/16.
//  Copyright © 2016 ScienceSoft. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

#import "NCAuthenticationViewController.h"
#import "NCDevicesTableViewController.h"
#import "NCNestAPIManager.h"
#import "NCSession.h"

@interface NCAuthenticationViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *authenticationWebView;
@property (strong, nonatomic) id<NCNestAuthAPIProtocol> nestAPIManager;
@property (strong, nonatomic) id<NCSessionWriteProtocol, NCSessionReadProtocol> session;

- (void)_configureNavigationBar;
- (void)_navigateToDevicesTableViewControllerAnimated:(BOOL)animated;
- (void)_loadAuthURL;

@end

@implementation NCAuthenticationViewController

#pragma mark - View's life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nestAPIManager = [NCNestAPIManager sharedInstance];
    self.session = [NCSession sharedInstance];
    [self _configureNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([self.session isValid]) {
        [self _navigateToDevicesTableViewControllerAnimated:NO];
    } else {
        self.authenticationWebView.delegate = self;
        [self _loadAuthURL];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Configure views

- (void)_configureNavigationBar {
    [self.navigationItem setTitle:NSLocalizedString(@"authenticationView_navigationTitle", nil)];
}

#pragma mark - UIViewViewDelegate's methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

/**
 * Intercept the requests to get the authorization code.
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
    NSURL *redirectURL = [[NSURL alloc] initWithString:kRedirectURL];
    
    if ([[url host] isEqualToString:[redirectURL host]]) {
        NSString *code = [self _codeValueFromURL:url];
        if(code != nil) {
            DDLogInfo(@"Authorization code was successfully retrieved: %@", code);
            [self.session setAuthorizationCode:code];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            __weak typeof(self) welf = self;
            [self.nestAPIManager exchangeCodeForTokenWithCompletion:^(NSError *error) {
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                if (error) {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"alertView_errorTitle", nil)
                                                                                       message:error.localizedDescription
                                                                                preferredStyle:UIAlertControllerStyleAlert];
                    
                    [welf presentViewController:alertController animated:YES completion:nil];
                } else {
                    [welf _navigateToDevicesTableViewControllerAnimated:YES];
                }
            }];
            return NO;
        } else {
            DDLogError(@"Error retrieving the authorization code.");
            return YES;
        }
    }
    
    return YES;
}

#pragma mark - Helpers

/**
 * Load's the auth url in the web view.
 */
- (void)_loadAuthURL {
    NSString *authorizationCodeURL = [self.nestAPIManager authorizationURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:authorizationCodeURL]];
    [self.authenticationWebView loadRequest:request];
}

/**
 *  Parses url to components and searches for code parameter
 *
 *  @param url NSURL, parsed url
 *
 *  @return NSString, code value if exists, otherwise nil
 */
- (NSString *)_codeValueFromURL:(NSURL *)url {
    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    for (NSURLQueryItem *queryItem in [components queryItems]) {
        if ([queryItem.name isEqualToString:kCodeKey]) {
            return queryItem.value;
        }
    }
    
    return nil;
}

#pragma mark - Navigation

/**
 *  Navigates to NEST Devices table view
 *
 *  @param animated BOOL, animated
 */
- (void)_navigateToDevicesTableViewControllerAnimated:(BOOL)animated {
    NCDevicesTableViewController *devicesTableViewController = [[NCDevicesTableViewController alloc] init];
    
    UINavigationController *devicesNavigationController = [[UINavigationController alloc] initWithRootViewController:devicesTableViewController];
    
    [self presentViewController:devicesNavigationController animated:YES completion:nil];
}

@end
