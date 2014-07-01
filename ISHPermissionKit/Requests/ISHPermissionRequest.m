//
//  ISHPermissionRequest.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequest.h"
@import CoreLocation;

@interface ISHPermissionRequest ()
@property (nonatomic, readwrite) ISHPermissionCategory permissionCategory;
@end

@implementation ISHPermissionRequest

- (ISHPermissionState)permissionState {
    NSAssert(false, @"Subclasses should implement permission state and not call super.");
    return [self internalPermissionState];
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    NSAssert(false, @"Subclasses should implement -requestUserPermissionWithCompletionBlock: and not call super.");
}

- (ISHPermissionState)internalPermissionState {
    NSNumber *state = [[NSUserDefaults standardUserDefaults] objectForKey:[self persistentIdentifier]];
    if (!state) {
        return ISHPermissionStateUnknown;
    }
    
    return [state integerValue];
}

- (void)setInternalPermissionState:(ISHPermissionState)state {    
    [[NSUserDefaults standardUserDefaults] setInteger:state forKey:[self persistentIdentifier]];
}

- (NSString *)persistentIdentifier {
    return [NSStringFromClass([self class]) stringByAppendingFormat:@"-%@", @(self.permissionCategory)];
}

- (BOOL)allowsConfiguration {
    return NO;
}

@end

NSString * const ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings = @"ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings";
