//
//  ISHPermissionRequestPhotoLibrary.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 27.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestPhotoLibrary.h"
@import AssetsLibrary;

@interface ISHPermissionRequestPhotoLibrary ()
@end

@implementation ISHPermissionRequestPhotoLibrary
- (ISHPermissionState)permissionState {
    ALAuthorizationStatus systemState = [ALAssetsLibrary authorizationStatus];
    switch (systemState) {
        case ALAuthorizationStatusAuthorized:
            return ISHPermissionStateGranted;
        case ALAuthorizationStatusDenied:
        case ALAuthorizationStatusRestricted:
            return ISHPermissionStateDenied;
        default:
            return [self internalPermissionState];
    }
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    NSAssert(completion, @"requestUserPermissionWithCompletionBlock requires a completion block");
    ISHPermissionState currentState = self.permissionState;
    if (!ISHPermissionStateAllowsUserPrompt(currentState)) {
        completion(self, currentState, nil);
        return;
    }
    
    ALAssetsLibrary *assetsLibrary = [ALAssetsLibrary new];
    
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        completion(self, self.permissionState, nil);
    } failureBlock:^(NSError *error) {
        completion(self, self.permissionState, error);
    }];
}

@end
