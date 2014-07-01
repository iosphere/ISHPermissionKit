//
//  ISHPermissionRequestHealth.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 01.07.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestHealth.h"
#import "ISHPermissionRequest+Private.h"

#ifdef __IPHONE_8_0
@import HealthKit;

@interface ISHPermissionRequestHealth ()
@property (nonatomic) HKHealthStore *store;
@end
#endif

@implementation ISHPermissionRequestHealth

- (BOOL)allowsConfiguration {
    return YES;
}

#ifdef __IPHONE_8_0
- (HKHealthStore *)store {
    if (!_store) {
        _store = [HKHealthStore new];
    }
    
    return _store;
}
#endif

+ (BOOL)useFallBack {
#ifndef __IPHONE_8_0
    return YES;
#endif
    return !(NSClassFromString(@"HKHealthStore"));
}

- (ISHPermissionState)permissionState {
    if ([ISHPermissionRequestHealth useFallBack]) {
        return ISHPermissionStateUnsupported;
    }
#ifdef __IPHONE_8_0
    NSMutableSet *allType = [NSMutableSet set];
    
    if (self.objectTypesRead.count) {
        [allType unionSet:self.objectTypesRead];
    }
    
    if (self.objectTypesWrite.count) {
        [allType unionSet:self.objectTypesWrite];
    }
    
    BOOL anyUndetermined = NO;
    NSUInteger countDenied = 0;
    NSUInteger countAuthorized = 0;
    
    for (HKObjectType *sampleType in allType) {
        HKAuthorizationStatus status = [self.store authorizationStatusForType:sampleType];
        switch (status) {
            case HKAuthorizationStatusNotDetermined:
                anyUndetermined = YES;
                break;
                
            case HKAuthorizationStatusSharingAuthorized:
                countAuthorized++;
                break;
                
            case HKAuthorizationStatusSharingDenied:
                countDenied++;
                break;
        }
    }
    
    if (anyUndetermined) {
        return [self internalPermissionState];
    }
    
    // for mixed results we simply vote:
    if (countDenied > countAuthorized) {
        return ISHPermissionStateDenied;
    }
#else
    return ISHPermissionStateUnsupported;
#endif
    return ISHPermissionStateAuthorized;
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    NSAssert(completion, @"requestUserPermissionWithCompletionBlock requires a completion block");
    ISHPermissionState currentState = self.permissionState;
    
    if (!ISHPermissionStateAllowsUserPrompt(currentState)) {
        completion(self, currentState, nil);
        return;
    }
    
#ifdef __IPHONE_8_0
    [self.store requestAuthorizationToShareTypes:self.objectTypesWrite
                                       readTypes:self.objectTypesRead
                                      completion:^(BOOL success, NSError *error) {
                                          dispatch_async(dispatch_get_main_queue(), ^{
#ifdef DEBUG
                                              if (error) {
                                                  NSLog(@"\n******\nAn error occured while requesting authorization for health kit, please check your project settings and entitlements.\n******\n");
                                                  NSLog(@"HealthKit error: %@", error);
                                              }
#endif
                                              completion(self, [self permissionState], error);
                                          });
                                      }];
#else
    completion(self, ISHPermissionStateUnsupported, nil);
#endif
}

@end
