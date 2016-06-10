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
 *  @return An instance of the appropriate ISHPermissionRequest subclass
 *          for the given category.
 */
+ (ISHPermissionRequest *)requestForCategory:(ISHPermissionCategory)category;

/**
 *  Check the permission state for a set of permissions.
 *
 *  @param categories Set of boxed ISHPermissionCategory to check for permission state.
 *
 *  @return A set of boxed ISHPermissionCategory values for which the
 *          user has granted permissions among the set of
 *          categories given as an argument.
 */
+ (NSSet<NSNumber *> *)grantedPermissionsForCategories:(NSSet<NSNumber *> *)categories;
@end

NS_ASSUME_NONNULL_END
