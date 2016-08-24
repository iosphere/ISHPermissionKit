//
//  ISHPermissionRequest+Private.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 27.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

/**
 *  These methods are available to subclasses. There should be no
 *  need to override these or to call them from outside of a subclass
 *  implementation.
 */
@interface ISHPermissionRequest (Subclasses)

/**
 *  @return The permission state saved internally, without
 *          considering state information available by the
 *          system frameworks.
 */
- (ISHPermissionState)internalPermissionState;

/**
 *  @param state The new internal permission state, which will
 *               be persisted.
 */
- (void)setInternalPermissionState:(ISHPermissionState)state;

/**
 *  This method verfies that the completion block is not nil
 *  (will asssert in non-release builds) and that the current
 *  state allows a user prompt.
 *
 *  Permission request subclasses should call this method in their
 *  implementation of requestUserPermissionWithCompletionBlock:
 *  and only continue when it returns YES. If it returns NO,
 *  the completion block is already called internally.
 *
 *  @param completion The completion block given to
 *  requestUserPermissionWithCompletionBlock:
 *
 *  @return YES, if the completion block is not nil and the
 *  current permission state allows a prompt.
 */
- (BOOL)mayRequestUserPermissionWithCompletionBlock:(nullable ISHPermissionRequestCompletionBlock)completion;

/**
 *  ISHPermissionKit communicates errors during permissions requests only if the error is
 *  not a result of the user denying the permission.
 *  The underlying APIs for each permission category use different error
 *  codes and domains. This method returns the provided error if:
 *  - the error domain is equal to requiredDomain
 *  - the error code is not contained in denialCodes
 */
+ (nullable NSError *)externalErrorForError:(nullable NSError *)error validationDomain:(nonnull NSString *)requiredDomain denialCodes:(nonnull NSSet<NSNumber *> *)denialCodes;

#if DEBUG
/**
 *  Most APIs that require permission also require the app to
 *  include one ore more static usage descriptions in its Info
 *  PLIST.
 *
 *  While debugging, ISHPermissionKit verifies that the info
 *  plist indeed contains the required usage descriptions.
 *
 *  Different descriptions are enforced on different versions
 *  of iOS, but since iOS 10 will enforce all of them,
 *  ISHPermissionKit will verify them regardless of the
 *  system version, too.
 *
 *  @sa https://developer.apple.com/library/ios/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html
 */
- (nullable NSArray<NSString *> *)staticAuthorizationTextKeys;
#endif

@end
