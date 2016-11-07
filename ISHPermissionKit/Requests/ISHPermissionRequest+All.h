//
//  ISHPermissionRequest+All.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 26.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequest.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  This category adds a factory method to instantiate request instances.
 */
@interface ISHPermissionRequest (All)

/**
 *  Factory method to instantiate ISHPermissionRequest instances.
 *
 *  @note When adding further permission categories, you must register
 *        your ISHPermissionRequest subclass in this method's
 *        implementation.
 *
 *  @param category The category for which to create a permission request.
 *
 *  @note Requests returned by this method are not configured. You may
 *        want to use ISHPermissionsViewController's permissionRequests
 *        property to get fully configured requests.
 *
 *  @sa allowsConfiguration
 *
 *  @return An instance of the appropriate ISHPermissionRequest subclass
 *          for the given category.
 */
+ (ISHPermissionRequest *)requestForCategory:(ISHPermissionCategory)category;


@end

NS_ASSUME_NONNULL_END
