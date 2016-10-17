//
//  ISHPermissionRequestContacts.m
//  ISHPermissionKit
//
//  Created by Hagi on 26/08/16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestContacts.h"
#import "ISHPermissionRequest+Private.h"

#ifdef ISHPermissionRequestContactsEnabled

@import Contacts;

@implementation ISHPermissionRequestContacts

- (ISHPermissionState)permissionState {
    if (![CNContactStore class]) {
        return ISHPermissionStateUnsupported;
    }

    return [self permissionStateForContactsState:[CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]];
}

- (ISHPermissionState)permissionStateForContactsState:(CNAuthorizationStatus)state {
    switch (state) {
        case CNAuthorizationStatusAuthorized:
            return ISHPermissionStateAuthorized;

        case CNAuthorizationStatusDenied:
        case CNAuthorizationStatusRestricted:
            return ISHPermissionStateDenied;

        case CNAuthorizationStatusNotDetermined:
            return ISHPermissionStateUnknown;
    }

    NSAssert(NO, @"Undefined permission state: %@", @(state));
    return [self internalPermissionState];
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }

    if (![CNContactStore class]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, ISHPermissionStateUnsupported, nil);
        });

        return;
    }

    [[CNContactStore new] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        NSSet *deniedError = [NSSet setWithObject:@(CNErrorCodeAuthorizationDenied)];
        NSError *externalError = [[self class] externalErrorForError:error validationDomain:CNErrorDomain denialCodes:deniedError];

        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, granted ? ISHPermissionStateAuthorized : ISHPermissionStateAuthorized, externalError);
        });
    }];
}

#if DEBUG
- (NSArray<NSString *> *)staticUsageDescriptionKeys {
    return @[@"NSContactsUsageDescription"];
}
#endif

@end

#endif
