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
        case AVAudioSessionRecordPermissionUndetermined:
            return [self internalPermissionState];
    }
#else
    return [self internalPermissionState];
#endif
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    NSAssert(completion, @"requestUserPermissionWithCompletionBlock requires a completion block");
    
    ISHPermissionState currentState = self.permissionState;
    if (!ISHPermissionStateAllowsUserPrompt(currentState)) {
        completion(self, currentState, nil);
        return;
    }
    
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setInternalPermissionState:granted ? ISHPermissionStateAuthorized : ISHPermissionStateDenied];
            completion(self, granted, nil);
        });
    }];
}

@end
