//
//  ISHPermissionRequestViewController.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISHPermissionCategory.h"

/**
 *  A UIViewController subclass that allows you to easily ask for the
 *  permission status regarding a permission category. You should not instantiate
 *  ISHPermissionRequestViewController objects directly.
 *  Instead, you create and instantiate subclasses of the ISHPermissionRequestViewController class.
 *
 *  Instances of this class are expected to be used in concert with ISHPermissionsViewController
 *  and to be returned from the ISHPermissionsViewControllerDataSource method:
 *
 *  @code
 *  - (ISHPermissionRequestViewController *)permissionsViewController:(ISHPermissionsViewController *)vc requestViewControllerForCategory:(ISHPermissionCategory)category {
 *       return [[YourPermissionRequestViewController alloc] init];
 *  }
 *  @endcode
 *
 *  Usually no further configuration is required on your part.
 *
 *  Your subclass can create a view with text, images, and buttons etc. explaining in greater
 *  detail why your app needs a certain permission. The subclass should contain buttons (or other
 *  controls) that trigger at least one of the actions listed below. A cancel button should call 
 *  changePermissionStateToAskAgainFromSender:. When overwriting one of the three actions,
 *  you must call super.
 */
@interface ISHPermissionRequestViewController : UIViewController

/**
 *  The permission category associated with this view controller. This is usually set by 
 *  the ISHPermissionsViewController.
 */
@property (nonatomic) ISHPermissionCategory permissionCategory;

/**
 *  User action to flag the permission category as "Don't ask again". This will lead 
 *  to the permission not being prompted again.
 *
 *  This will not present the system dialog asking for the user permission.
 *  This will dismiss the view controller immediately.
 *
 *  @note If you subclass this method, you must call super at some point.
 *
 *  @param sender The sender (e.g., a button) that triggered the call.
 */
- (IBAction)changePermissionStateToDontAskFromSender:(nullable id)sender NS_REQUIRES_SUPER;

/**
 *  User action to skip the current permission dialog. The permission category
 *  will be presented to the user again when requested.
 *
 *  This will not present the system dialog asking for the user permission.
 *  This will dismiss the view controller immediately.
 *
 *  @note If you subclass this method, you must call super at some point.
 *
 *  @param sender The sender (e.g., a button) that triggered the call.
 */
- (IBAction)changePermissionStateToAskAgainFromSender:(nullable id)sender NS_REQUIRES_SUPER;

/**
 *  User action to present the system dialog for the current permission category.
 *
 *  This will dismiss the view controller once the user has taken a decision.
 *
 *  @note If you subclass this method, you must call super at some point.
 *
 *  @param sender The sender (e.g., a button) that triggered the call.
 */
- (IBAction)requestPermissionFromSender:(nullable id)sender NS_REQUIRES_SUPER;

@end
