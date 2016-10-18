//
//  ISHPermissionRequestPhotoCamera.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 27.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestPhotoCamera.h"
#import "ISHPermissionRequest+Private.h"

#ifdef ISHPermissionRequestCameraEnabled

@import AVFoundation;

@implementation ISHPermissionRequestPhotoCamera

- (ISHPermissionState)permissionState {
    NSString *mediaTypeStringCamera = AVMediaTypeVideo;
    AVCaptureDevice *inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:mediaTypeStringCamera];
    if (![inputDevice hasMediaType:mediaTypeStringCamera]) {
        // this is mainly the simulator
        return ISHPermissionStateUnsupported;
    }
    
    switch ([AVCaptureDevice authorizationStatusForMediaType:mediaTypeStringCamera]) {
        case AVAuthorizationStatusAuthorized:
            return ISHPermissionStateAuthorized;

        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            return ISHPermissionStateDenied;
            
        case AVAuthorizationStatusNotDetermined:
            return [self internalPermissionState];
    }
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }
    
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            ISHPermissionState state = granted ? ISHPermissionStateAuthorized : ISHPermissionStateDenied;
            completion(self, state, nil);
        });
    }];
}

#if DEBUG
- (NSArray<NSString *> *)staticUsageDescriptionKeyss {
    return @[@"NSCameraUsageDescription"];
}
#endif

@end

#endif
