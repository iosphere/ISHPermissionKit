//
//  ISHPermissionRequestNotificationsLocal.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 27.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestNotificationsLocal.h"
#import "ISHPermissionRequest+Private.h"

@interface ISHPermissionRequestNotificationsLocal ()
@property (copy) ISHPermissionRequestCompletionBlock completionBlock;
@end

@implementation ISHPermissionRequestNotificationsLocal

- (instancetype)init {
    self = [super init];
    if (self) {
        self.notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert
                                                                      categories:nil];
    }
    return self;
}

- (BOOL)allowsConfiguration {
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (ISHPermissionState)permissionState {
    if (![UIUserNotificationSettings class]) {
        return ISHPermissionStateAuthorized;
    }
    
    UIUserNotificationSettings *noticationSettings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    
    if (!noticationSettings || (noticationSettings.types == UIUserNotificationTypeNone)) {
        return [self internalPermissionState];
    }
    
    // To be discussed: should types/categories differing from self.noticationSettings lead to denied state?
    return ISHPermissionStateAuthorized;
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }

    if (!self.notificationSettings) {
        NSAssert(NO, @"Requested notification settings should be set for request before requesting user permission");
        return;
    }

    if (![[[UIApplication sharedApplication] delegate] respondsToSelector:@selector(application:didRegisterUserNotificationSettings:)]) {
        NSAssert(NO, @"AppDelegate must implement application:didRegisterUserNotificationSettings: and post ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings notification");
        return;
    }

    // avoid asking again (system state does not correctly reflect if we asked already).
    [self setInternalPermissionState:ISHPermissionStateDoNotAskAgain];
    
    self.completionBlock = completion;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings:)
                                                 name:ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings
                                               object:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:self.notificationSettings];
}

- (void)ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings:(NSNotification *)note {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.completionBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.completionBlock(self, self.permissionState, nil);
            self.completionBlock = nil;
        });
    }
}

@end
