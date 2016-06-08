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
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }

    // TODO: migrate to PHPhotoLibrary API on iOS 9+ (https://github.com/iosphere/ISHPermissionKit/issues/42)

    ALAssetsLibrary *assetsLibrary = [ALAssetsLibrary new];

    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (!group) {
            // ensure that completion is only called once
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(self, self.permissionState, nil);
                *stop = YES;
            });
        }
    } failureBlock:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, self.permissionState, nil);
        });
    }];
}

@end
