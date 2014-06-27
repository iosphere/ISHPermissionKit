//
//  ISHPermissionRequest.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISHPermissionCategory.h"

typedef NS_ENUM(NSUInteger, ISHPermissionState) {
    ISHPermissionStateUnknown = 0,
    ISHPermissionStateUnsupported = 1,
    ISHPermissionStateNeverAsked = 100,
    ISHPermissionStateAskAgain = 101,
    ISHPermissionStateDontAsk = 110,
    ISHPermissionStateDenied = 403,
    ISHPermissionStateAuthorized = 200,
};

@class ISHPermissionRequest;

typedef void (^ISHPermissionRequestCompletionBlock)(ISHPermissionRequest *request, ISHPermissionState state, NSError *error);

/**
 *  Permission request provide information about the current permission state of the associated category. 
 *  It can also be used to request the user's permission via the system dialogue or to remember the user's
 *  desire to not be asked again.
 *
 *  Instances should be created via the category class method:
 *  @code
 *  + (ISHPermissionRequest *)requestForCategory:(ISHPermissionCategory)category;
 *  @endcode
 */
@interface ISHPermissionRequest : NSObject

/// The permission category associated with the request.
@property (readonly) ISHPermissionCategory permissionCategory;

/**
 *  @return The current permission state.
 *  @note Calling this method does not trigger any user interaction.
 */
- (ISHPermissionState)permissionState;

/**
 *  If possible this presents the user permissions dialogue. This might not be possible
 *  e.g. if it is already denied, authorized or the user does not want to be asked again.
 *
 *  @param completion The block is called once the user has made a decision. 
 *                    The block is called right away if no dialogue was presented.
 */
- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion;
@end

static inline NSString *ISHStringFromPermissionState(ISHPermissionState state) {
    switch (state) {
        case ISHPermissionStateUnknown:
            return @"ISHPermissionStateUnknown";
        case ISHPermissionStateUnsupported:
            return @"ISHPermissionStateUnsupported";
        case ISHPermissionStateNeverAsked:
            return @"ISHPermissionStateNeverAsked";
        case ISHPermissionStateAskAgain:
            return @"ISHPermissionStateAskAgain";
        case ISHPermissionStateDontAsk:
            return @"ISHPermissionStateDontAsk";
        case ISHPermissionStateDenied:
            return @"ISHPermissionStateDenied";
        case ISHPermissionStateAuthorized:
            return @"ISHPermissionStateAuthorized";

    }
}

static inline BOOL ISHPermissionStateAllowsUserPrompt(ISHPermissionState state) {
    return (state != ISHPermissionStateDenied) && (state != ISHPermissionStateAuthorized) && (state != ISHPermissionStateDontAsk) && (state != ISHPermissionStateUnsupported);
}

/**
 *  When using ISHPermissionKit to register for UILocalNotifications, the app delegate must implement 
 *  -application:didRegisterUserNotificationSettings: and post a notification with name 
 *  'ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings' to inform any pending 
 *  requests that a change occured.
 */
extern NSString * const ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings;
