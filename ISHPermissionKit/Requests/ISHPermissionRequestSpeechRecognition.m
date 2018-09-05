//
//  ISHPermissionRequestSpeechRecognition.m
//  ISHPermissionKit
//
//  Created by Hagi on 25/08/16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestSpeechRecognition.h"
#import "ISHPermissionRequest+Private.h"

#ifdef ISHPermissionRequestSpeechEnabled

@import Speech;

@implementation ISHPermissionRequestSpeechRecognition

- (ISHPermissionState)permissionState {
    if (@available(iOS 10.0, *)) {
        return [self permissionStateForSpeechState:[SFSpeechRecognizer authorizationStatus]];
    } else {
        return ISHPermissionStateUnsupported;
    }
}

- (ISHPermissionState)permissionStateForSpeechState:(SFSpeechRecognizerAuthorizationStatus)state API_AVAILABLE(ios(10.0)){
    switch ([SFSpeechRecognizer authorizationStatus]) {
        case SFSpeechRecognizerAuthorizationStatusAuthorized:
            return ISHPermissionStateAuthorized;

        case SFSpeechRecognizerAuthorizationStatusDenied:
        case SFSpeechRecognizerAuthorizationStatusRestricted:
            return ISHPermissionStateDenied;

        case SFSpeechRecognizerAuthorizationStatusNotDetermined:
            return ISHPermissionStateUnknown;
    }

    NSAssert(NO, @"Undefined permission state: %@", @(state));
    return [self internalPermissionState];
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }

    if (@available(iOS 10.0, *)) {
        [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(self, [self permissionStateForSpeechState:status], nil);
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
    return @[@"NSSpeechRecognitionUsageDescription"];
}
#endif

@end

#endif
