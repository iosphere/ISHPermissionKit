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
    if (![MPMediaLibrary respondsToSelector:@selector(requestAuthorization:)]) {
        // prior to iOS 9.3, authorization is not required
        return ISHPermissionStateAuthorized;
    }

    return [self permissionStateForMediaLibraryState:[MPMediaLibrary authorizationStatus]];
}

- (ISHPermissionState)permissionStateForMediaLibraryState:(MPMediaLibraryAuthorizationStatus)state {
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

    if (![MPMediaLibrary respondsToSelector:@selector(requestAuthorization:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, ISHPermissionStateUnsupported, nil);
        });

        return;
    }

    [MPMediaLibrary requestAuthorization:^(MPMediaLibraryAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, [self permissionStateForMediaLibraryState:status], nil);
        });
    }];
}

#if DEBUG
- (NSArray<NSString *> *)staticUsageDescriptionKeys {
    return @[@"NSAppleMusicUsageDescription"];
}
#endif

@end

#endif
