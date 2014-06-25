//
//  ISHPermissionRequestLocation.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 26.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestLocation.h"
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
        case kCLAuthorizationStatusAuthorizedAlways:
            return ISHPermissionStateGranted;

        case kCLAuthorizationStatusAuthorizedWhenInUse:

            if (self.permissionCategory == ISHPermissionCategoryLocationAlways) {
                return ISHPermissionStateDenied;
            } else {
                return ISHPermissionStateGranted;
            }

        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            return ISHPermissionStateDenied;

        default:
            // handle with internal permission state
            break;
    }

    return [self internalPermissionState];
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    NSAssert(completion, @"requestUserPermissionWithCompletionBlock requires a completion block");
    ISHPermissionState currentState = self.permissionState;

    if ((currentState == ISHPermissionStateDenied) || (currentState == ISHPermissionStateGranted)) {
        completion(self, currentState, nil);
        return;
    }

    self.completionBlock = completion;

    if (self.permissionCategory == ISHPermissionCategoryLocationAlways) {
        [self.locationManager requestAlwaysAuthorization];
    } else {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if ((status != kCLAuthorizationStatusNotDetermined) && self.completionBlock) {
        self.completionBlock(self, self.permissionState, nil);
        self.completionBlock = nil;
    }
}

@end
