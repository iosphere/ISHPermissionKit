//
//  ISHPermissionsViewController.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ISHPermissionRequestViewController.h"
#import "ISHPermissionRequest.h"

@class ISHPermissionsViewController;

@protocol ISHPermissionsViewControllerDatasource <NSObject>
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

@protocol ISHPermissionsViewControllerDelegate <NSObject>

- (ISHPermissionRequestViewController *)permissionsViewControllerDidComplete:(ISHPermissionsViewController *)vc;
@end

typedef void (^ISHPermissionsViewControllerCompletionBlock)(void);

@interface ISHPermissionsViewController : UIViewController
+ (instancetype)permissionsViewControllerWithCategories:(NSArray *)categories;
@property (nonatomic, weak) id <ISHPermissionsViewControllerDatasource> dataSource;
@property (nonatomic, weak) id <ISHPermissionsViewControllerDelegate> delegate;
@property (strong) ISHPermissionsViewControllerCompletionBlock completionBlock;
@end
