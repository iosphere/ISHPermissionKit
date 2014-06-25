//
//  ISHPermissionRequest.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequest.h"
@import CoreLocation;

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
        return ISHPermissionStateNeverAsked;
    }
    
    return [state integerValue];
}

- (void)setInternalPermissionState:(ISHPermissionState)state {
    if (state == ISHPermissionStateGranted || state == ISHPermissionStateDenied) {
        // these are not internal states
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setInteger:state forKey:[self persistentIdentifier]];
}

- (NSString *)persistentIdentifier {
    return [NSStringFromClass([self class]) stringByAppendingFormat:@"-%@", @(self.permissionCategory)];
}

@end
