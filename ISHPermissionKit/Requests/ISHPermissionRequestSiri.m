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
    if (@available(iOS 10.0, *)) {
        return [self permissionStateForSiriState:[INPreferences siriAuthorizationStatus]];
    } else {
        return ISHPermissionStateUnsupported;
    }
}

- (ISHPermissionState)permissionStateForSiriState:(INSiriAuthorizationStatus)siriState API_AVAILABLE(ios(10.0)){
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

    if (@available(iOS 10.0, *)) {
        [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(self, [self permissionStateForSiriState:status], nil);
            });
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, ISHPermissionStateUnsupported, nil);
        });
    }
}

#if DEBUG
- (NSArray<NSString *> *)staticUsageDescriptionKeyss {
    return @[@"NSSiriUsageDescription"];
}
#endif

@end

#endif
