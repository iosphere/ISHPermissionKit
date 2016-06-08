//
//  ISHPermissionRequestHealth.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 01.07.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestHealth.h"
#import "ISHPermissionRequest+Private.h"

#ifdef ISHPermissionRequestHealthKitEnabled
@import HealthKit;


@interface ISHPermissionRequestHealth ()
@property (nonatomic) HKHealthStore *store;
@end
#endif

@implementation ISHPermissionRequestHealth

- (instancetype)init {
    self = [super init];
    #ifndef ISHPermissionRequestHealthKitEnabled
    NSAssert(false, @"HealthKit permission requests require the use of the ISHPermissionKit+HealthKit framework "
                    @"or static library. This assertion was most likely triggered because your app links to the "
                    @"wrong target. Please check your project settings. If you use CocoaPods, you must use the"
                    @"ISHPermissionKit/Health pod in your Podfile.");
    #endif
    return self;
}

- (BOOL)allowsConfiguration {
    return YES;
}

#ifdef ISHPermissionRequestHealthKitEnabled
- (HKHealthStore *)store {
    if (!_store) {
        _store = [HKHealthStore new];
    }
    
    return _store;
}
#else 
- (id)store {
    return nil;
}
#endif

+ (BOOL)useFallBack {
#ifndef ISHPermissionRequestHealthKitEnabled
    return YES;
#else
    return ![HKHealthStore isHealthDataAvailable];
#endif
}

- (ISHPermissionState)permissionState {
    if ([ISHPermissionRequestHealth useFallBack]) {
        return ISHPermissionStateUnsupported;
    }
#ifndef ISHPermissionRequestHealthKitEnabled
    return ISHPermissionStateUnsupported; // should already be covered by above Fallback
#else
    NSMutableSet *allTypes = [NSMutableSet set];
    NSSet *readableTypes = self.objectTypesRead;

    if (readableTypes.count) {
        [allTypes unionSet:readableTypes];
    }

    NSSet *writeableTypes = self.objectTypesWrite;

    if (writeableTypes.count) {
        [allTypes unionSet:writeableTypes];
    }
    
    BOOL anyUndetermined = NO;
    NSUInteger countDenied = 0;
    NSUInteger countAuthorized = 0;
    
    for (HKObjectType *sampleType in allTypes) {
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
    return ISHPermissionStateAuthorized;
#endif  // #ifndef ISHPermissionRequestHealthKitEnabled
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }
    
#ifdef ISHPermissionRequestHealthKitEnabled
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
