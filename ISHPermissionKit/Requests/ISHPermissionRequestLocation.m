//
//  ISHPermissionRequestLocation.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 26.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestLocation.h"
#import "ISHPermissionRequest+Private.h"

@import CoreLocation;
@import UIKit;

@interface ISHPermissionRequestLocation () <CLLocationManagerDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL initialChangeAuthorizationStatusCallWasIgnored;
@property (nonatomic, copy) ISHPermissionRequestCompletionBlock completionBlock;
@end

@implementation ISHPermissionRequestLocation
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        [_locationManager setDelegate:self];
    }

    return _locationManager;
}

- (void)dealloc {
    [_locationManager setDelegate:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (ISHPermissionState)permissionState {
    CLAuthorizationStatus systemState = [CLLocationManager authorizationStatus];

    switch (systemState) {
#ifndef __IPHONE_8_0
        case kCLAuthorizationStatusAuthorized:
            return ISHPermissionStateAuthorized;
#else
        case kCLAuthorizationStatusAuthorizedAlways:
            return ISHPermissionStateAuthorized;

        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if (self.permissionCategory == ISHPermissionCategoryLocationAlways) {
                if (self.internalPermissionState == ISHPermissionStateDenied) {
                    return ISHPermissionStateDenied;
                }
                return ISHPermissionStateAskAgain;
            } else {
                return ISHPermissionStateAuthorized;
            }
#endif
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            return ISHPermissionStateDenied;

        default:
            return [self internalPermissionState];
    }
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }

    self.completionBlock = completion;
    
    if ([self useFallback]) {
        // iOS7 fallback
        [self.locationManager startUpdatingLocation];
        return;
    }
#ifdef __IPHONE_8_0
    if (self.permissionCategory == ISHPermissionCategoryLocationAlways) {
        if ([ISHPermissionRequestLocation grantedWhenInUse]) {
            /*
             Unfortunately in the case from WhenInUse to Always the delegate is not called,
             when/if the user taps cancel (b/c the status is still WhenInUse).
             The only way to determine that the user made a decision is
             to listen to UIApplicationDidBecomeActiveNotification
             which is triggered once the alert is dismissed (for both buttons).
             */
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UIApplicationDidBecomeActiveNotification:)
                                                         name:UIApplicationDidBecomeActiveNotification
                                                       object:nil];
        }
        [self.locationManager requestAlwaysAuthorization];
    } else {
        [self.locationManager requestWhenInUseAuthorization];
    }
#endif
}

#ifdef __IPHONE_8_0
+ (BOOL)grantedWhenInUse {
    return ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse);
}
#endif

- (BOOL)useFallback {
#ifdef __IPHONE_8_0 // only for builds with base sdk of iOS8 and higher
    // when building for iOS8 we need to feature check if running on iOS7:
    return !([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]);
#else
    return YES;
#endif
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    BOOL notDetermined = (status == kCLAuthorizationStatusNotDetermined);
#ifdef __IPHONE_8_0
    BOOL grantedWhenInUse = (status == kCLAuthorizationStatusAuthorizedWhenInUse);
    BOOL requestingAlways = (self.permissionCategory == ISHPermissionCategoryLocationAlways);
#else
    // If we are building with iOS7, there is no always/whenInUse case
    BOOL grantedWhenInUse = NO;
    BOOL requestingAlways = NO;
#endif
    
    if (notDetermined || (grantedWhenInUse && requestingAlways)) {
        /* early calls to this delegate method are ignored, if this is not the change we are waiting for.
           e.g. the location manager calls this method immediately when requesting always permissions,
           if WhenInUse was already granted.
        */
        if (!self.initialChangeAuthorizationStatusCallWasIgnored) {
            self.initialChangeAuthorizationStatusCallWasIgnored = YES;
            return;
        }
    }
    
    [self handleCompletionBlock];

    if ([self useFallback]) {
        [self.locationManager stopUpdatingLocation];
    }
}

- (void)handleCompletionBlock {
    if (!self.completionBlock) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        ISHPermissionState currentState = self.permissionState;
        self.completionBlock(self, currentState, nil);
        self.completionBlock = nil;
    });
}

#ifdef __IPHONE_8_0
- (void)UIApplicationDidBecomeActiveNotification:(NSNotification *)note {;
    BOOL requestingAlways = (self.permissionCategory == ISHPermissionCategoryLocationAlways);
    if ([ISHPermissionRequestLocation grantedWhenInUse] && requestingAlways) {
        /* this happens if the user was asked for additional always permission
           if whenInUse permission were already granted.
           the didChangeAuthorizationStatus delegate call will not be called
           as there is no change. We get called here, because the alert was dismissed.
           We can now call the completion block. 
           We also need an internal state to save that the user was asked, 
           as future calls to requestAlwaysAuthorization do nothing. */
        [self setInternalPermissionState:ISHPermissionStateDenied];
        [self handleCompletionBlock];
    }
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}
#endif

@end
