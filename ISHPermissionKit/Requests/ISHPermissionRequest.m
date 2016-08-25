//
//  ISHPermissionRequest.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequest.h"
#import "ISHPermissionRequest+Private.h"
@import CoreLocation;
@import UIKit;

@interface ISHPermissionRequest ()
@property (nonatomic, readwrite) ISHPermissionCategory permissionCategory;
@end

@implementation ISHPermissionRequest

- (ISHPermissionState)permissionState {
    NSAssert(NO, @"Subclasses should implement permission state and not call super.");
    return [self internalPermissionState];
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    NSAssert(NO, @"Subclasses should implement -requestUserPermissionWithCompletionBlock: and not call super.");
}

- (BOOL)mayRequestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
#if DEBUG
    [self verifyUsageDescriptions];
#endif

    if (!completion) {
        NSAssert(completion, @"requestUserPermissionWithCompletionBlock: requires a completion block");
        return NO;
    }

    ISHPermissionState currentState = self.permissionState;

    if (!ISHPermissionStateAllowsUserPrompt(currentState)) {
        completion(self, currentState, nil);
        return NO;
    }

    return YES;
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

+ (nullable NSError *)externalErrorForError:(nullable NSError *)error validationDomain:(nonnull NSString *)requiredDomain denialCodes:(nonnull NSSet<NSNumber *> *)denialCodes {
    if (![error.domain isEqualToString:requiredDomain]) {
        return nil;
    }
    if ([denialCodes containsObject:@(error.code)]) {
        return nil;
    }
    return error;
}

#pragma mark - Usage Key Verification

#if DEBUG
- (NSArray<NSString *> *)staticUsageDescriptionKeys {
    return nil;
}

- (void)verifyUsageDescriptions {
    // we need to get the app's info plist, not the framework's
    Class delegateClass = [UIApplication sharedApplication].delegate.class;
    NSBundle *appBundle = [NSBundle bundleForClass:delegateClass];
    NSDictionary *infoPlist = appBundle.infoDictionary;

    for (NSString *usageKey in [self staticUsageDescriptionKeys]) {
        id content = infoPlist[usageKey];
        NSString *stringContent = [content isKindOfClass:[NSString class]] ? (NSString *)content : nil;
        NSAssert(stringContent.length > 0, @"You must provide %@ in your info plist when using %@", usageKey, ISHStringFromPermissionCategory(self.permissionCategory));
    }
}
#endif

@end

NSString * const ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings = @"ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings";
