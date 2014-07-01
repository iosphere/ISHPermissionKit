//
//  ISHPermissionRequestNotificationsLocal.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 27.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISHPermissionRequest.h"

@interface ISHPermissionRequestNotificationsLocal : ISHPermissionRequest
#ifdef __IPHONE_8_0
@property (nonatomic) UIUserNotificationSettings *noticationSettings;
#endif
@end
