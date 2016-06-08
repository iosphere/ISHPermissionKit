//
//  ISHPermissionRequestEventStore.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 02.07.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestEventStore.h"
#import "ISHPermissionRequest+Private.h"

@import EventKit;

@interface ISHPermissionRequestEventStore ()
@property (nonatomic) EKEventStore *eventStore;
@end

@implementation ISHPermissionRequestEventStore
- (EKEntityType)entityType {
    if (self.permissionCategory == ISHPermissionCategoryReminders) {
        return EKEntityTypeReminder;
    }
    
    return EKEntityTypeEvent;
}

- (EKEventStore *)eventStore {
    if (!_eventStore) {
        _eventStore = [EKEventStore new];
    }
    
    return _eventStore;
}

- (ISHPermissionState)permissionState {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:[self entityType]];
    
    switch (status) {
        case EKAuthorizationStatusAuthorized:
            return ISHPermissionStateAuthorized;
            
        case EKAuthorizationStatusRestricted:
        case EKAuthorizationStatusDenied:
            return ISHPermissionStateDenied;
            
        case EKAuthorizationStatusNotDetermined:
            return [self internalPermissionState];
    }
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }
    
    [self.eventStore requestAccessToEntityType:[self entityType] completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, granted ? ISHPermissionStateAuthorized : ISHPermissionStateDenied, error);
        });
    }];
}

@end
