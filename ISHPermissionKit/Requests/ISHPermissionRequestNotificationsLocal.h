//
//  ISHPermissionRequestNotificationsLocal.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 27.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISHPermissionRequest.h"

/**
 *  Permission request for sending local notifications.
 *
 *  @sa ISHPermissionCategoryNotificationLocal
 */
@interface ISHPermissionRequestNotificationsLocal : ISHPermissionRequest

/**
 *  Settings to configure the notification.
 *
 *  @sa ISHPermissionCategoryNotificationLocal
 */
@property (nonatomic, nonnull) UIUserNotificationSettings *notificationSettings;

@end
