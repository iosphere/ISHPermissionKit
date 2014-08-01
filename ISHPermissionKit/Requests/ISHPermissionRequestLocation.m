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

@interface ISHPermissionRequestLocation () <CLLocationManagerDelegate>
@property (nonatomic) CLLocationManager *locationManager;
@property (strong) ISHPermissionRequestCompletionBlock completionBlock;
@end

@implementation ISHPermissionRequestLocation
- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        [_locationManager setDelegate:self];
    }

    return _locationManager;
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
    NSAssert(completion, @"requestUserPermissionWithCompletionBlock requires a completion block");
    ISHPermissionState currentState = self.permissionState;

    if (!ISHPermissionStateAllowsUserPrompt(currentState)) {
        completion(self, currentState, nil);
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
        [self.locationManager requestAlwaysAuthorization];
    } else {
        [self.locationManager requestWhenInUseAuthorization];
    }
#endif
}

- (BOOL)useFallback {
#ifdef __IPHONE_8_0 // only for builds with base sdk of iOS8 and higher
    // when building for iOS8 we need to feature check if running on iOS7:
    return !([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]);
#else
    return YES;
#endif
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if ((status != kCLAuthorizationStatusNotDetermined) && self.completionBlock) {
        ISHPermissionState currentState = self.permissionState;
        self.completionBlock(self, currentState, nil);
        self.completionBlock = nil;
        
        if ([self useFallback]) {
            [self.locationManager stopUpdatingLocation];
        }
    }
}

@end
