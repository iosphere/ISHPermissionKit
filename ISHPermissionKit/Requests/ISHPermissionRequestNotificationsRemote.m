//
//  ISHPermissionRequestNotificationsRemote.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 01.09.2015.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestNotificationsRemote.h"
#import "ISHPermissionRequest+Private.h"

@interface ISHPermissionRequestNotificationsLocal ()
@property (copy) ISHPermissionRequestCompletionBlock completionBlockRemote;
@end

@implementation ISHPermissionRequestNotificationsRemote


- (ISHPermissionState)permissionState {
    if (![[UIApplication sharedApplication] respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        return ISHPermissionStateAuthorized;
    }
    
    if(![[UIApplication sharedApplication] isRegisteredForRemoteNotifications]) {
        return [self internalPermissionState];
    }
    
    return ISHPermissionStateAuthorized;
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    NSAssert(self.noticationSettings, @"Requested notification settings should be set for request before requesting user permission");
    // ensure that the app delegate implements the didRegisterForRemoteNotificationsWithDeviceToken:
    NSAssert([[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)], @"AppDelegate must implement application:didRegisterForRemoteNotificationsWithDeviceToken: and post notification ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings");
    
    // register for remote notification
    ISHPermissionState currentState = self.permissionState;
    if (ISHPermissionStateAllowsUserPrompt(currentState)
        && [[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    if (!ISHPermissionStateAllowsUserPrompt(currentState)) {
        completion(self, currentState, nil);
        return;
    }
    
    // avoid asking again (system state does not correctly reflect if we asked already).
    [self setInternalPermissionState:ISHPermissionStateDoNotAskAgain];
    
    self.completionBlockRemote = completion;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ISHPermissionNotificationApplicationDidRegisterForRemoteNotificationsWithDeviceToken:)
                                                 name:ISHPermissionNotificationApplicationDidRegisterForRemoteNotificationsWithDeviceToken
                                               object:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:self.noticationSettings];
}

- (void)ISHPermissionNotificationApplicationDidRegisterForRemoteNotificationsWithDeviceToken:(NSNotification *)note {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.completionBlockRemote) {
        self.completionBlockRemote(self, self.permissionState, nil);
        self.completionBlockRemote = nil;
    }
}

@end
