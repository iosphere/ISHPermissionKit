//
//  ISHPermissionCategory.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//


/**
 *  Permission categories describe types of permissions on iOS.
 *  Each is related to a specific PermissionRequest.
 *  @note Values assigned to each category must not be changed, as 
 *        they may have been persisted on user devices.
 */
typedef NS_ENUM(NSUInteger, ISHPermissionCategory) {
    /**
     *  Permission required for step counting and motion activity queries. 
     *  See reference documentation for CoreMotion.
     */
    ISHPermissionCategoryActivity = 1000,
    /**
     *  Permission required to use the user's location at any time,
     *  including monitoring for regions, visits, or significant location changes.
     */
    ISHPermissionCategoryLocationAlways = 3100,
    /**
     *  Permission required to use the user's location only when your app
     *  is visible to them.
     */
    ISHPermissionCategoryLocationWhenInUse = 3200,
    /**
     *  Permission required to record the user's microphone input.
     */
    ISHPermissionCategoryMicrophone = 4000,
    /**
     *  Permission required to access the user's photo library.
     */
    ISHPermissionCategoryPhotoLibrary = 5000,
    /**
     *  Permission required to access the user's camera.
     */
    ISHPermissionCategoryPhotoCamera = 5100,
    /**
     *  Permission required to schedule local notifications.
     */
    ISHPermissionCategoryNotificationLocal = 6100,
};


/**
 *  @param category A value from the ISHPermissionCategory enum.
 *
 *  @return A string representation of an ISHPermissionCategory enum value. (Used mainly for debugging).
 */
static inline NSString *ISHStringFromPermissionCategory(ISHPermissionCategory category) {
    switch (category) {
        case ISHPermissionCategoryActivity:
            return @"ISHPermissionCategoryActivity";
        case ISHPermissionCategoryLocationAlways:
            return @"ISHPermissionCategoryLocationAlways";
        case ISHPermissionCategoryLocationWhenInUse:
            return @"ISHPermissionCategoryLocationWhenInUse";
        case ISHPermissionCategoryMicrophone:
            return @"ISHPermissionCategoryMicrophone";
        case ISHPermissionCategoryPhotoLibrary:
            return @"ISHPermissionCategoryPhotoLibrary";
        case ISHPermissionCategoryPhotoCamera:
            return @"ISHPermissionCategoryPhotoCamera";
        case ISHPermissionCategoryNotificationLocal:
            return @"ISHPermissionCategoryNotificationLocal";
    }
}
