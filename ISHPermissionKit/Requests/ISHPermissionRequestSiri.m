//
//  ISHPermissionRequestSiri.m
//  ISHPermissionKit
//
//  Created by Hagi on 24/08/16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestSiri.h"
#import "ISHPermissionRequest+Private.h"

#ifdef ISHPermissionRequestSiriEnabled

@import Intents;

@implementation ISHPermissionRequestSiri

- (ISHPermissionState)permissionState {
    if (![INPreferences class]) {
        return ISHPermissionStateUnsupported;
    }

    return [self permissionStateForSiriState:[INPreferences siriAuthorizationStatus]];
}

- (ISHPermissionState)permissionStateForSiriState:(INSiriAuthorizationStatus)siriState {
    switch (siriState) {
        case INSiriAuthorizationStatusAuthorized:
            return ISHPermissionStateAuthorized;

        case INSiriAuthorizationStatusDenied:
        case INSiriAuthorizationStatusRestricted:
            return ISHPermissionStateDenied;

        case INSiriAuthorizationStatusNotDetermined:
            return ISHPermissionStateUnknown;
    }

    NSAssert(NO, @"Undefined permission state: %@", @(siriState));
    return [self internalPermissionState];
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }

    if (![INPreferences class]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, ISHPermissionStateUnsupported, nil);
        });

        return;
    }

    [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, [self permissionStateForSiriState:status], nil);
        });
    }];
}

#if DEBUG
- (NSArray<NSString *> *)staticUsageDescriptionKeyss {
    return @[@"NSSiriUsageDescription"];
}
#endif

@end

#endif
