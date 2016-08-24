//
//  ISHPermissionRequestSiri.m
//  ISHPermissionKit
//
//  Created by Hagi on 24/08/16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestSiri.h"
#ifdef NSFoundationVersionNumber_iOS_9_0

#import "ISHPermissionRequest+Private.h"
#import <Intents/Intents.h>

@implementation ISHPermissionRequestSiri

- (ISHPermissionState)permissionState {
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

    [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, [self permissionStateForSiriState:status], nil);
        });
    }];
}

@end
#endif
