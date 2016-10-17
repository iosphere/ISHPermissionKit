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

@implementation ISHPermissionRequestHealth

- (BOOL)allowsConfiguration {
    return YES;
}

- (HKHealthStore *)store {
    if (!_store) {
        _store = [HKHealthStore new];
    }
    
    return _store;
}

+ (BOOL)useFallBack {
    return ![HKHealthStore isHealthDataAvailable];
}

- (ISHPermissionState)permissionState {
    if ([ISHPermissionRequestHealth useFallBack]) {
        return ISHPermissionStateUnsupported;
    }

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
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }
    
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
                                              NSError *externalError = [ISHPermissionRequest externalErrorForError:error validationDomain:HKErrorDomain denialCodes:[NSSet setWithObject:@(HKErrorAuthorizationDenied)]];
                                              completion(self, [self permissionState], externalError);
                                          });
                                      }];
}

#if DEBUG
- (NSString *)staticUsageDescriptionKeys {
    NSMutableArray<NSString *> *keys = [@[] mutableCopy];

    if (self.objectTypesRead.count) {
        [keys addObject:@"NSHealthShareUsageDescription"];
    }

    if (self.objectTypesWrite.count) {
        [keys addObject:@"NSHealthUpdateUsageDescription"];
    }

    return [keys copy];
}
#endif

@end

#endif
