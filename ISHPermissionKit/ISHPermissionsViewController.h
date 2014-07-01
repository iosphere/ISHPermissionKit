//
//  ISHPermissionsViewController.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISHPermissionRequestViewController.h"

@class ISHPermissionRequest;
@protocol ISHPermissionsViewControllerDataSource;
@protocol ISHPermissionsViewControllerDelegate;

typedef void (^ISHPermissionsViewControllerCompletionBlock)(void);

/**
 *  A UIViewController allowing to ask the user for one or more permission categories.
 *  
 *  Once presented, the view controller handles all user interaction through
 *  its child viewcontrollers (which are subclasses of ISHPermissionRequestViewController).
 *  
 *  You should use the designated constructor +permissionsViewControllerWithCategories:.
 */
@interface ISHPermissionsViewController : UIViewController

/**
 *  Creates a new instance of ISHPermissionsViewController to request permission for a single category
 *  or a sequence of categories.
 *
 *  @param categories An NSArray of ISHPermissionCategory values boxed in NSNumber objects. 
 *                    The permission categories that should be requested from the user. 
 *                    Only those categories that allow a user prompt will be respected.
 *  @param dataSource The dataSource is required and must provide one instance of a
 *                    ISHPermissionRequestViewController for each requested ISHPermissionCategory. 
 *                    If it implements the optional didConfigureRequest: method, it will be asked
 *                    to configure any request that allows configuration.
 *
 *  @warning Returns nil if non of the categories allow a user prompt.
 *
 *  @return Returns a new instance of ISHPermissionsViewController for all categories that allow 
 *          a user prompt. Nil if non of the categories allow a user prompt.
 */
+ (instancetype)permissionsViewControllerWithCategories:(NSArray *)categories dataSource:(id <ISHPermissionsViewControllerDataSource>)dataSource;

/**
 *  The dataSource is required and must provide one instance of a 
 *  ISHPermissionRequestViewController for each requested ISHPermissionCategory.
 */
@property (nonatomic, readonly, weak) id <ISHPermissionsViewControllerDataSource> dataSource;

/**
 *  The optional delegate is informed by the ISHPermissionsViewController once all permission categories
 *  have been handled. If you do not set a delegate, the view controller will simply be dismissed once finished.
 *  If you do set a delegate, the delegate is responsible for dismissing the view controller.
 */
@property (nonatomic, weak) id <ISHPermissionsViewControllerDelegate> delegate;

/**
 *  The optional completion block is called once all permission categories
 *  have been handled. If you did not set a delegate, the completionBlock is called
 *  once the dismissal of the view controller has been completed.
 *  Otherwise it is called immediately after informing the delegate.
 */
@property (copy) ISHPermissionsViewControllerCompletionBlock completionBlock;

@end


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
 *  This is the appropriate moment to configure the request further if this is needed.
 *  Currently this is only needed/possible for ISHPermissionRequestNotificationsLocal.
 *
 *  @param vc      The view controller that currently handles permissions.
 *  @param request The request that will be handled by the vc once this method returns.
 *                 Direct interaction other than configuration should be avoided.
 */
- (void)permissionsViewController:(ISHPermissionsViewController *)vc didConfigureRequest:(ISHPermissionRequest *)request;
@end

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

