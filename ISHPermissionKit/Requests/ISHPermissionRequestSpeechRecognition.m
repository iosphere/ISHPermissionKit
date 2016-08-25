//
//  ISHPermissionRequestSpeechRecognition.m
//  ISHPermissionKit
//
//  Created by Hagi on 25/08/16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestSpeechRecognition.h"
#ifdef NSFoundationVersionNumber_iOS_9_0

#import "ISHPermissionRequest+Private.h"

@import Speech;

@implementation ISHPermissionRequestSpeechRecognition

- (ISHPermissionState)permissionState {
    return [self permissionStateForPhotosState:[SFSpeechRecognizer authorizationStatus]];
}

- (ISHPermissionState)permissionStateForPhotosState:(SFSpeechRecognizerAuthorizationStatus)state {
    if (![SFSpeechRecognizer class]) {
        return ISHPermissionStateUnsupported;
    }

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

    if (![SFSpeechRecognizer class]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, ISHPermissionStateUnsupported, nil);
        });

        return;
    }

    [SFSpeechRecognizer requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, [self permissionStateForPhotosState:status], nil);
        });
    }];
}

#if DEBUG
- (NSArray<NSString *> *)staticUsageDescriptionKeyss {
    return @[@"NSSpeechRecognitionUsageDescription"];
}
#endif

@end
#endif
