//
//  ISHPermissionRequestAccount.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 01.07.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestAccount.h"
#import "ISHPermissionRequest+Private.h"

@import Accounts;

@interface ISHPermissionRequestAccount ()
@property (nonatomic) ACAccountStore *accountStore;
@property (nonatomic) ACAccountType *accountType;
@end

@implementation ISHPermissionRequestAccount

- (BOOL)allowsConfiguration {
    // Facebook requires further configuration
    return (self.permissionCategory == ISHPermissionCategorySocialFacebook);
}

- (NSString *)accountTypeIdentifier {
    switch (self.permissionCategory) {
        case ISHPermissionCategorySocialFacebook:
            return ACAccountTypeIdentifierFacebook;
            
        case ISHPermissionCategorySocialTwitter:
            return ACAccountTypeIdentifierTwitter;
            
        case ISHPermissionCategorySocialSinaWeibo:
            return ACAccountTypeIdentifierSinaWeibo;
            
        case ISHPermissionCategorySocialTencentWeibo:
            return ACAccountTypeIdentifierTencentWeibo;
            
        default:
            return nil;
    }
}

- (ACAccountType *)accountType {
    if (!_accountType) {
        NSString *identifier = self.accountTypeIdentifier;
        NSAssert(identifier, @"Permissions request for accounts requires an identifier, e.g., ACAccountTypeIdentifierFacebook");
        _accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:identifier];
    }
    
    return _accountType;
}

- (ACAccountStore *)accountStore {
    if (!_accountStore) {
        _accountStore = [ACAccountStore new];
    }
    
    return _accountStore;
}

- (ISHPermissionState)permissionState {
    BOOL granted = [self.accountType accessGranted];
    
    if (granted) {
        return ISHPermissionStateAuthorized;
    }
    
    // if it is not granted we need to fall back to our internal data
    return [self internalPermissionState];
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }
    
    [self.accountStore requestAccessToAccountsWithType:self.accountType
                                               options:self.options
                                            completion:^(BOOL granted, NSError *error) {
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    ISHPermissionState state = granted ? ISHPermissionStateAuthorized : ISHPermissionStateDenied;
                                                    [self setInternalPermissionState:state];
                                                    completion(self, state, error);
                                                });
                                            }];
}

@end
