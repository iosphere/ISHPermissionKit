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

- (ISHPermissionState)permissionState {
    if (![[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        return ISHPermissionStateUnsupported;
    }
    
    return [super permissionState];
}

@end
