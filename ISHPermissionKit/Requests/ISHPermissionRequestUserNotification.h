//
//  ISHPermissionRequestUserNotification.h
//  ISHPermissionKit
//
//  Created by Hagi on 25/08/16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import <ISHPermissionKit/ISHPermissionKit.h>
#ifdef NSFoundationVersionNumber_iOS_9_0
@import UserNotifications;

/**
 *  Permission request to present local and/or remote
 *  notifications.
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
