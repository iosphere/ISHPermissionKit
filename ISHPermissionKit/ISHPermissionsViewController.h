//
//  ISHPermissionsViewController.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISHPermissionCategory.h"

@class ISHPermissionRequest;
@class ISHPermissionRequestViewController;
@protocol ISHPermissionsViewControllerDataSource;
@protocol ISHPermissionsViewControllerDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 Completion block without arguments or return value.
 */
typedef void (^ISHPermissionsViewControllerCompletionBlock)(void);

#pragma mark - View Controller

/**
 *  A UIViewController allowing to ask the user for one or more permission categories.
 *  
 *  Once presented, the view controller handles all user interaction through
 *  its child view controllers (which are subclasses of ISHPermissionRequestViewController).
 *  
 *  You should use the factory method +permissionsViewControllerWithCategories: to instantiate
 *  your instance of ISHPermissionsViewController.
 */
@interface ISHPermissionsViewController : UIViewController

/**
 *  Creates a new instance of ISHPermissionsViewController to request permission for a single category
 *  or a sequence of categories.
 *
 *  @param categories An array of ISHPermissionCategory values boxed in NSNumber objects.
 *                    The permission categories that should be requested from the user. 
 *                    Only those categories that allow a user prompt will be presented.
 *  @param dataSource The dataSource is required and must provide one instance of a
 *                    ISHPermissionRequestViewController for each requested ISHPermissionCategory. 
 *                    If it implements the optional didConfigureRequest: method, it will be asked
 *                    to configure any request that allows configuration.
 *
 *  @warning Returns nil if none of the categories allows a user prompt.
 *
 *  @return Returns a new instance of ISHPermissionsViewController for all categories that allow 
 *          a user prompt. Nil if non of the categories allow a user prompt.
 */
+ (nullable instancetype)permissionsViewControllerWithCategories:(NSArray<NSNumber *> *)categories dataSource:(id<ISHPermissionsViewControllerDataSource>)dataSource;

/**
 *  Initialization should preferably be done within this method and
 *  called from all supported initializers of a class. Will be called
 *  for you from initWithNibName:bundle:, initWithCoder:, and init.
 *
 *  The default implementation ensures that commonInit is only called
 *  once when going through the above-mentioned initializers.
 *
 *  You must call it yourself when you support additional initializers,
 *  or overwrite the above-mentioned initializers without calling super.
 */
- (void)commonInit NS_REQUIRES_SUPER;

/**
 *  The dataSource is required and must provide one instance of a 
 *  ISHPermissionRequestViewController for each requested ISHPermissionCategory.
 */
@property (nonatomic, readonly, weak, nullable) id<ISHPermissionsViewControllerDataSource> dataSource;

/**
 *  The optional delegate is informed by the ISHPermissionsViewController once all permission categories
 *  have been handled. If you do not set a delegate, the view controller will simply be dismissed once finished.
 *  If you do set a delegate, the delegate is responsible for dismissing the view controller.
 */
@property (nonatomic, weak, nullable) id<ISHPermissionsViewControllerDelegate> delegate;

/**
 *  The optional completion block is called once all permission categories
 *  have been handled. If you did not set a delegate, the completionBlock is called
 *  once the dismissal of the view controller has been completed.
 *  Otherwise it is called immediately after informing the delegate.
 */
@property (copy, nullable) ISHPermissionsViewControllerCompletionBlock completionBlock;

@end

#pragma mark - Protocols
#pragma mark Data Source

/**
 *  The data source is responsible for providing the view controllers for 
 *  the individual permission categories and to configure permission requests 
 *  that require configuration.
 */
@protocol ISHPermissionsViewControllerDataSource <NSObject>;

/**
 *  Called by the permissions view controller on its data source when it needs an individual
 *  permission request view controller. The returned view controller will be associated with 
 *  the permissions view controller and its permission category will also be set automatically.
 *
 *  @param vc       The view controller that currently handles permissions.
 *  @param category The category for which a request view view controller is required.
 *
 *  @return An instance of a subclass of ISHPermissionRequestViewController.
 */
- (ISHPermissionRequestViewController *)permissionsViewController:(ISHPermissionsViewController *)vc requestViewControllerForCategory:(ISHPermissionCategory)category;

@optional

/**
 *  Called by the ISHPermissionsViewController before starting to handle the given request.
 *  This is the appropriate moment to configure the request further if needed.
 *  Currently this is needed/possible for ISHPermissionRequestNotificationsLocal, 
 *  ISHPermissionCategorySocialFacebook, and ISHPermissionRequestHealth.
 *
 *  @sa [ISHPermissionRequest allowsConfiguration]
 *
 *  @param vc      The view controller that currently handles permissions.
 *  @param request The request that will be handled by the vc once this method returns.
 *                 Direct interaction other than configuration should be avoided.
 */
- (void)permissionsViewController:(ISHPermissionsViewController *)vc didConfigureRequest:(ISHPermissionRequest *)request;

@end

#pragma mark Delegate

/**
 *  The delegate is informed by the ISHPermissionsViewController once all permission categories 
 *  have been handled.
 */
@protocol ISHPermissionsViewControllerDelegate <NSObject>

/**
 *  Called by the ISHPermissionsViewController once all permission categories
 *  have been handled.
 *
 *  @note This method will be called prior to calling the 
 *        ISHPermissionsViewController's completionBlock (optional).
 *
 *  @param vc ISHPermissionsViewController instance that completed.
 */
- (void)permissionsViewControllerDidComplete:(ISHPermissionsViewController *)vc;

@end

NS_ASSUME_NONNULL_END
