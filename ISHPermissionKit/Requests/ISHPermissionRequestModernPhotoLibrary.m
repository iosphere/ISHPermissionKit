//
//  ISHPermissionRequestModernPhotoLibrary.m
//  ISHPermissionKit
//
//  Created by Hagi on 24/08/16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestModernPhotoLibrary.h"
#import "ISHPermissionRequest+Private.h"
#import <Photos/Photos.h>

@implementation ISHPermissionRequestModernPhotoLibrary

- (ISHPermissionState)permissionState {
    if (![PHPhotoLibrary class]) {
        return ISHPermissionStateUnsupported;
    }

    return [self permissionStateForPhotosState:[PHPhotoLibrary authorizationStatus]];
}

- (ISHPermissionState)permissionStateForPhotosState:(PHAuthorizationStatus)state {
    switch ([PHPhotoLibrary authorizationStatus]) {
        case PHAuthorizationStatusAuthorized:
            return ISHPermissionStateAuthorized;

        case PHAuthorizationStatusDenied:
        case PHAuthorizationStatusRestricted:
            return ISHPermissionStateDenied;

        case PHAuthorizationStatusNotDetermined:
            return ISHPermissionStateUnknown;
    }

    NSAssert(NO, @"Undefined permission state: %@", @(state));
    return [self internalPermissionState];
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }

    if (![PHPhotoLibrary class]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, ISHPermissionStateUnsupported, nil);
        });

        return;
    }

    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, [self permissionStateForPhotosState:status], nil);
        });
    }];
}

#if DEBUG
- (NSArray<NSString *> *)staticUsageDescriptionKeyss {
    return @[@"NSPhotoLibraryUsageDescription"];
}
#endif

@end
