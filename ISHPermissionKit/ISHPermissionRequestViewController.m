//
//  ISHPermissionRequestViewController.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestViewController.h"
#import "ISHPermissionsViewController.h"
#import "ISHPermissionRequestViewControllerDelegate.h"
#import "ISHPermissionRequest+All.h"

@interface ISHPermissionRequestViewController ()
@property (weak, nonatomic) id <ISHPermissionRequestViewControllerDelegate> permissionDelegate;
@property (nonatomic) ISHPermissionRequest *permissionRequest;
@end

@implementation ISHPermissionRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAssert(self.permissionDelegate, @"permissionDelegate is should not be nil");
    self.permissionRequest = [ISHPermissionRequest requestForCategory:self.permissionCategory];
}

- (IBAction)changePermissionStateToDontAskFromSender:(id)sender {
    [self.permissionRequest setInternalPermissionState:ISHPermissionStateDontAsk];
    [self didComplete];
}

- (IBAction)changePermissionStateToAskAgainFromSender:(id)sender {
    [self.permissionRequest setInternalPermissionState:ISHPermissionStateAskAgain];
    [self didComplete];
}

- (IBAction)requestPermissionFromSender:(id)sender {
    [self.permissionRequest requestUserPermissionWithCompletionBlock:^(ISHPermissionRequest *request, ISHPermissionState state, NSError *error) {
        [self didComplete];
    }];
}

- (void)didComplete {
    [self.permissionDelegate permissionRequestViewController:self didCompleteWithState:self.permissionRequest.permissionState];
}

@end
