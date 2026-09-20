//
//  ISHPermissionRequestEventStore.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 02.07.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestEventStore.h"
#import "ISHPermissionRequest+Private.h"

#if defined(ISHPermissionRequestCalendarEnabled) || defined(ISHPermissionRequestRemindersEnabled)

@import EventKit;

@interface ISHPermissionRequestEventStore ()
@property (nonatomic) EKEventStore *eventStore;
@end

@implementation ISHPermissionRequestEventStore

- (EKEntityType)entityType {

#ifdef ISHPermissionRequestRemindersEnabled
    if (self.permissionCategory == ISHPermissionCategoryReminders) {
        return EKEntityTypeReminder;
    }
#endif

#ifdef ISHPermissionRequestCalendarEnabled
    if (self.permissionCategory == ISHPermissionCategoryEvents) {
        return EKEntityTypeEvent;
    }
#endif

    NSAssert(NO, @"Invalid permission category: %@", @(self.permissionCategory));
    return 0;
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
        // EKAuthorizationStatusFullAccess, added in iOS 17, has the same value
        // as the now-deprecated EKAuthorizationStatusAuthorized.
        case EKAuthorizationStatusAuthorized:
            return ISHPermissionStateAuthorized;

        // Also iOS 17: the user granted permission to add events but not to
        // read them. ISHPermissionState has no finer distinction to report.
        case EKAuthorizationStatusWriteOnly:
            return ISHPermissionStateAuthorized;
            
        case EKAuthorizationStatusRestricted:
        case EKAuthorizationStatusDenied:
            return ISHPermissionStateDenied;
            
        case EKAuthorizationStatusNotDetermined:
            return [self internalPermissionState];
    }

    // A status added by a future SDK.
    return ISHPermissionStateUnknown;
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }
    
    [self.eventStore requestAccessToEntityType:[self entityType] completion:^(BOOL granted, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *externalError = [ISHPermissionRequest externalErrorForError:error validationDomain:EKErrorDomain denialCodes:[NSSet setWithObject:@(EKErrorEventStoreNotAuthorized)]];
            completion(self, granted ? ISHPermissionStateAuthorized : ISHPermissionStateDenied, externalError);
        });
    }];
}

#if DEBUG
- (NSArray<NSString *> *)staticUsageDescriptionKeys {
#ifdef ISHPermissionRequestRemindersEnabled
    if (self.permissionCategory == ISHPermissionCategoryReminders) {
        return @[@"NSRemindersUsageDescription"];
    }
#endif

#ifdef ISHPermissionRequestCalendarEnabled
    if (self.permissionCategory == ISHPermissionCategoryEvents) {
        return @[@"NSCalendarsUsageDescription"];
    }
#endif

    return @[];
}
#endif

@end

#endif
