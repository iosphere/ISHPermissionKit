//
//  ISHPermissionRequestMusicLibrary.m
//  ISHPermissionKit
//
//  Created by Hagi on 26/08/16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestMusicLibrary.h"
#import "ISHPermissionRequest+Private.h"

#ifdef ISHPermissionRequestMusicLibraryEnabled

@import MediaPlayer;

@implementation ISHPermissionRequestMusicLibrary

- (ISHPermissionState)permissionState {
    if (@available(iOS 9.3, *)) {
        return [self permissionStateForMediaLibraryState:[MPMediaLibrary authorizationStatus]];
    } else {
        // prior to iOS 9.3, authorization is not required
        return ISHPermissionStateAuthorized;
    }
}

- (ISHPermissionState)permissionStateForMediaLibraryState:(MPMediaLibraryAuthorizationStatus)state API_AVAILABLE(ios(9.3)){
    switch (state) {
        case MPMediaLibraryAuthorizationStatusAuthorized:
            return ISHPermissionStateAuthorized;

        case MPMediaLibraryAuthorizationStatusDenied:
        case MPMediaLibraryAuthorizationStatusRestricted:
            return ISHPermissionStateDenied;

        case MPMediaLibraryAuthorizationStatusNotDetermined:
            return ISHPermissionStateUnknown;
    }

    NSAssert(NO, @"Undefined permission state: %@", @(state));
    return [self internalPermissionState];
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }

    if (@available(iOS 9.3, *)) {
        [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(self, [self permissionStateForMediaLibraryState:status], nil);
            });
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, ISHPermissionStateUnsupported, nil);
        });
    }
}

#if DEBUG
- (NSArray<NSString *> *)staticUsageDescriptionKeys {
    return @[@"NSAppleMusicUsageDescription"];
}
#endif

@end

#endif
