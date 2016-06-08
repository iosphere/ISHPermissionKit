//
//  ISHPermissionRequest.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISHPermissionCategory.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  Enumeration for possible permission states.
 *
 *  These are used instead of the permission state values
 *  provided by the system to provide unified states
 *  across all permission categories.
 */
typedef NS_ENUM(NSUInteger, ISHPermissionState) {
    /**
     *  THe state of the permission could not be determined.
     */
    ISHPermissionStateUnknown = 0,
    
    /**
     *  The permission is not supported on the current device or SDK. 
     *  This may be the case for CoreMotion-related APIs on devices
     *  such as the iPhone 4S, or for Camera permission on the Simulator.
     *
     * @note Does not allow user prompt.
     */
    ISHPermissionStateUnsupported = 501,
    
    /**
     *  The user has been asked for permission before through internal UI
     *  (without presenting the system dialog) and wanted
     *  to be asked again. No final decision has been made.
     */
    ISHPermissionStateAskAgain = 100,
    
    /**
     *  The user has been asked for permission before through internal UI
     *  (without presenting the system dialog) and does not want
     *  to be asked again. No final decision has been made.
     *
     *  @note Does not allow user prompt.
     */
    ISHPermissionStateDoNotAskAgain = 406,

    /**
     *  The user denied the permission through system UI. 
     *  To recover, the user must go to the system settings.
     *
     *  On iOS 8 and later, you can send the user to the app's
     *  settings by using the following code:
     *
     *  @code
     *  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
     *  @endcode
     *
     *  @note Does not allow user prompt.
     */
    ISHPermissionStateDenied = 403,
    
    /**
     *  The user granted the permission through system UI.
     *
     *  @note Does not allow user prompt.
     */
    ISHPermissionStateAuthorized = 200,
};

@class ISHPermissionRequest;

/**
 *  Block that takes three parameters and returns void.
 *
 *  @param request  The request that has completed.
 *  @param state    The new state of the associated category.
 *  @param error    An error, if it has occurred. May be nil.
 *
 *  @sa requestUserPermissionWithCompletionBlock:
 */
typedef void (^ISHPermissionRequestCompletionBlock)(ISHPermissionRequest *request, ISHPermissionState state, NSError * _Nullable error);

/**
 *  Permission requests provide information about the current permission state of the associated category.
 *  It can also be used to request the user's permission via the system dialog or to remember the user's
 *  desire not to be asked again.
 *
 *  The actual interaction is handled by subclasses. With the exception of those subclasses that 
 *  require more configuration, subclasses are "hidden" and should be transparent to the developer 
 *  using this framework.
 *
 *  Instances should be created via the category class method:
 *  @code
 *  + (ISHPermissionRequest *)requestForCategory:(ISHPermissionCategory)category;
 *  @endcode
 */
@interface ISHPermissionRequest : NSObject

/**
 *  The permission category associated with the request. Cannot be changed.
 * 
 *  @sa requestForCategory:
 */
@property (nonatomic, readonly) ISHPermissionCategory permissionCategory;

/**
 *  Subclasses must implement this method to reflect the correct state.
 *
 *  Ideally, permissionState should check the system authorization state first
 *  and should return appropriate internal enum values from ISHPermissionState. 
 *  If the system state is unavailable or is similar to, e.g., kCLAuthorizationStatusNotDetermined
 *  then this method should return the persisted internalPermissionState.
 *  Subclasses should try to map system provided states to ISHPermissionState without 
 *  resorting to the internalPermissionState as much as possible.
 *
 *  @return The current permission state.
 *  @note Calling this method does not trigger any user interaction.
 */
- (ISHPermissionState)permissionState;

/**
 *  If possible, this presents the user permissions dialog. This might not be possible
 *  if, e.g., it has already been denied, authorized, or the user does not want to be asked again.
 *
 *  @param completion The block is called once the user has made a decision. 
 *                    The block is called right away if no dialog was presented. The block may be
 *                    copied, so use weak references whenever possible. It is always called on
 *                    the main queue.
 */
- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion;

/**
 *  Some permission requests allow or require further configuration
 *  (such as those for local notifications and Health app). Subclasses for such
 *  permission categories should overwrite this method and return YES.
 *  The default implementation returns NO. 
 *
 *  @return Boolean value indicating if the request  
 *          allows further configuration.
 */
- (BOOL)allowsConfiguration;

@end


/**
 *  Used for debugging purposes, not localized.
 *
 *  @param state A permission state value.
 *
 *  @return A string representation of a permission state enum value.
 */
static inline NSString *ISHStringFromPermissionState(ISHPermissionState state) {
    switch (state) {
        case ISHPermissionStateUnknown:
            return @"ISHPermissionStateUnknown";
        case ISHPermissionStateUnsupported:
            return @"ISHPermissionStateUnsupported";
        case ISHPermissionStateAskAgain:
            return @"ISHPermissionStateAskAgain";
        case ISHPermissionStateDoNotAskAgain:
            return @"ISHPermissionStateDoNotAskAgain";
        case ISHPermissionStateDenied:
            return @"ISHPermissionStateDenied";
        case ISHPermissionStateAuthorized:
            return @"ISHPermissionStateAuthorized";
    }

    NSLog(@"Invalid state: %lu", (unsigned long)state);
    return @"";
}

/**
 *  @param state A permission state value.
 *
 *  @return A boolean value determining whether the user should be prompted again
 *          regarding the given permission state.
 */
static inline BOOL ISHPermissionStateAllowsUserPrompt(ISHPermissionState state) {
    return (state == ISHPermissionStateUnknown) || (state == ISHPermissionStateAskAgain);
}

/**
 *  When using ISHPermissionKit to register for local and user-facing remote notifications, 
 *  the app delegate must implement
 *  -application:didRegisterUserNotificationSettings: and post a notification with name
 *  'ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings' to inform 
 *  any pending requests that a change occured.
 *
 *  You can also use the convenience function ISHPermissionPostNotificationDidRegisterUserNotificationSettings(self).
 *
 *  @sa ISHPermissionCategoryNotificationLocal
 *  @sa ISHPermissionCategoryNotificationRemote
 */
extern NSString * const ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings;

/**
 *  Convenience function to register for local and user-facing remote notifications.
 *
 *  @sa ISHPermissionCategoryNotificationLocal
 *  @sa ISHPermissionCategoryNotificationRemote
 *  @sa ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings
 */
static inline void ISHPermissionPostNotificationDidRegisterUserNotificationSettings(_Nullable id object) {
    [[NSNotificationCenter defaultCenter] postNotificationName:ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings
                                                        object:object];
}

NS_ASSUME_NONNULL_END
