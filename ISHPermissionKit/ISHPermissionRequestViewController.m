//
//  ISHPermissionRequestViewController.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestViewController.h"
#import "ISHPermissionRequestViewControllerDelegate.h"
#import "ISHPermissionRequest+All.h"
#import "ISHPermissionRequest+Private.h"

@interface ISHPermissionRequestViewController ()
@property (weak, nonatomic) id <ISHPermissionRequestViewControllerDelegate> permissionDelegate;
@property (nonatomic) ISHPermissionRequest *permissionRequest;
@end

@implementation ISHPermissionRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSAssert(self.permissionDelegate, @"PermissionDelegate should not be nil");
    NSAssert(self.permissionRequest, @"PermissionRequest should not be nil");
}

- (IBAction)changePermissionStateToDontAskFromSender:(id)sender {
    [self changePermissionToInternalState:ISHPermissionStateDoNotAskAgain];
}

- (IBAction)changePermissionStateToAskAgainFromSender:(id)sender {
    [self changePermissionToInternalState:ISHPermissionStateAskAgain];
}

- (void)changePermissionToInternalState:(ISHPermissionState)state {
    [self.permissionRequest setInternalPermissionState:state];
    [self didCompleteWithPermissionState:state];
}

- (IBAction)requestPermissionFromSender:(id)sender {
    [self.permissionRequest requestUserPermissionWithCompletionBlock:^(ISHPermissionRequest *request, ISHPermissionState state, NSError *error) {
        [self didCompleteWithPermissionState:state];
    }];
}

- (void)didCompleteWithPermissionState:(ISHPermissionState)state {
    [self.permissionDelegate permissionRequestViewController:self didCompleteWithState:state];
}

@end
