//
//  ISHPermissionRequestPhotoLibrary.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 27.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestPhotoLibrary.h"
#import "ISHPermissionRequest+Private.h"

@import AssetsLibrary;

@interface ISHPermissionRequestPhotoLibrary ()
@end

@implementation ISHPermissionRequestPhotoLibrary
- (ISHPermissionState)permissionState {
    ALAuthorizationStatus systemState = [ALAssetsLibrary authorizationStatus];
    switch (systemState) {
        case ALAuthorizationStatusAuthorized:
            return ISHPermissionStateAuthorized;
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
        if (!group) {
            // ensure that completion is only called once
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(self, self.permissionState, nil);
            });
        }
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, self.permissionState, nil);
        });
    }];
}

@end
