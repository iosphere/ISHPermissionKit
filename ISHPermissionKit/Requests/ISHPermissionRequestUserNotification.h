//
//  ISHPermissionRequestUserNotification.h
//  ISHPermissionKit
//
//  Created by Hagi on 25/08/16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequest.h"

#ifdef ISHPermissionRequestNotificationsEnabled
#ifdef NSFoundationVersionNumber_iOS_9_0

#import <UserNotifications/UserNotifications.h>

/**
 *  Permission request to present local and/or remote
 *  notifications.
 *
 *  The underlying API to get the current permission state
 *  is asynchronous, so we cannot guarantee that
 *  `permissionState` always returns the latest state. This
 *  class performs an asynchronous update whenever it is
 *  instantiated, so you can create a new instance to trigger
 *  a state refresh.
 *
 *  The value returned in the completion block when requesting
 *  permission is always current.
 *
 *  @sa ISHPermissionCategoryUserNotification
 */
@interface ISHPermissionRequestUserNotification : ISHPermissionRequest

/**
 *  The options can be configured by the data source. The permission
 *  state is authorized when any option (desired or not) was granted.
 *
 *  Defaults to UNAuthorizationOptionAlert.
 *
 *  @sa -permissionsViewController:didConfigureRequest:
 */
@property (nonatomic) UNAuthorizationOptions desiredOptions;

@end

#endif
#endif
