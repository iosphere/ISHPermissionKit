//
//  ISHPermissionRequestNotificationsRemote.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 01.09.2015.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestNotificationsRemote.h"
#import "ISHPermissionRequest+Private.h"

@implementation ISHPermissionRequestNotificationsRemote

#ifdef __IPHONE_8_0

- (ISHPermissionState)permissionState {
    if (!NSClassFromString(@"UIUserNotificationSettings")) {
        return ISHPermissionStateAuthorized;
    }
    
    if(![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        return [self internalPermissionState];
    }
    
    return ISHPermissionStateAuthorized;
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (ISHPermissionStateAllowsUserPrompt(self.permissionState)) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    [super requestUserPermissionWithCompletionBlock:completion];
}

#else

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    completion(self, ISHPermissionStateAuthorized, nil);
}

- (ISHPermissionState)permissionState {
    return ISHPermissionStateUnsupported;
}

#endif
@end
