//
//  ISHPermissionRequestUserNotification.m
//  ISHPermissionKit
//
//  Created by Hagi on 25/08/16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestUserNotification.h"
#ifdef NSFoundationVersionNumber_iOS_9_0
#import "ISHPermissionRequest+Private.h"

@implementation ISHPermissionRequestUserNotification

- (instancetype)init {
    self = [super init];

    if (self && [UNUserNotificationCenter class]) {
        // we can only update the internal state asynchrounously,
        // so we do it as early as possible
        [self updateInternalPermissionState];
        self.desiredOptions = UNAuthorizationOptionAlert;
    }

    return self;
}

- (void)updateInternalPermissionState {
    [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        ISHPermissionState state = [self permissionStateForNotificationSettings:settings];
        [self setInternalPermissionState:state];
    }];
}

- (BOOL)allowsConfiguration {
    return YES;
}

- (ISHPermissionState)permissionState {
    if (![UIUserNotificationSettings class]) {
        // no need to request permission before iOS 8
        return ISHPermissionStateAuthorized;
    }

    if (![UNUserNotificationCenter class]) {
        // cannot request using the new API: should use
        // ISHPermissionCategoryNotificationRemote/...Local
        return ISHPermissionStateUnsupported;
    }

    // we cannot get the current state synchrounously, but update
    // it when initializing the class
    return [self internalPermissionState];
}

- (ISHPermissionState)permissionStateForNotificationSettings:(UNNotificationSettings *)settings {
    switch (settings.authorizationStatus) {
        case UNAuthorizationStatusAuthorized:
            return ISHPermissionStateAuthorized;

        case UNAuthorizationStatusDenied:
            return ISHPermissionStateDenied;

        case UNAuthorizationStatusNotDetermined:
            return ISHPermissionStateUnknown;
    }

    NSAssert(NO, @"Undefined permission state: %@", @(settings.authorizationStatus));
    return [self internalPermissionState];
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }

    if (![UNUserNotificationCenter class]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, ISHPermissionStateUnsupported, nil);
        });

        return;
    }

    [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:self.desiredOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        // granted is only YES when all options were granted, but our auth status
        // should reflect whether it is generally possible to use the API, i.e.,
        // any option was granted
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            dispatch_async(dispatch_get_main_queue(), ^{
                ISHPermissionState newState = [self permissionStateForNotificationSettings:settings];
                [self setInternalPermissionState:newState];
                completion(self, newState, error);
            });
        }];
    }];
}

@end
#endif
