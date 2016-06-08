//
//  ISHPermissionRequestMicrophone.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 27.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestMicrophone.h"
#import "ISHPermissionRequest+Private.h"

@import AVFoundation;

@implementation ISHPermissionRequestMicrophone

- (ISHPermissionState)permissionState {
#ifdef __IPHONE_8_0 // only for builds with base sdk of iOS8 and higher
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    if (![audioSession respondsToSelector:@selector(recordPermission)]) {
        // iOS7 fallback
        return [self internalPermissionState];
    }
    
    AVAudioSessionRecordPermission systemState = [audioSession recordPermission];
    switch (systemState) {
        case AVAudioSessionRecordPermissionDenied:
            return ISHPermissionStateDenied;
        case AVAudioSessionRecordPermissionGranted:
            return ISHPermissionStateAuthorized;
        case AVAudioSessionRecordPermissionUndetermined: {
            ISHPermissionState internalState = [self internalPermissionState];
            if (internalState == ISHPermissionStateAuthorized || internalState == ISHPermissionStateDenied) {
                /* the internal state falsely stores an invalid value that conflicts with 'undetermined'
                   (the result of the user permissions request was stored is stored for backwards
                   compatability reasons, as iOS7 does not provide a query method.) */
                return ISHPermissionStateUnknown;
            }
            return internalState;
        }
    }
#else
    return [self internalPermissionState];
#endif
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }
    
    AVAudioSession * audioSession = [AVAudioSession sharedInstance];
    [audioSession requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ISHPermissionState state = granted ? ISHPermissionStateAuthorized : ISHPermissionStateDenied;
#ifdef __IPHONE_8_0
            if (![audioSession respondsToSelector:@selector(recordPermission)]) {
#endif
                // set internal state to result of permission request, if
                // a) not building against iOS8
                // b) not running on iOS8 or later
                // -> when we can't retrieve the current state later.
                [self setInternalPermissionState:state];
#ifdef __IPHONE_8_0
            }
#endif
            completion(self, state, nil);
        });
    }];
}

@end
