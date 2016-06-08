//
//  ISHPermissionRequestViewController_private.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 26.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

@protocol ISHPermissionRequestViewControllerDelegate;
@class ISHPermissionRequest;

/**
 Private header for usage within the framework.
 */
@interface ISHPermissionRequestViewController (Private)
/**
 Sets the controller's permission delegate.
 @param permissionDelegate The new delegate.
 */
- (void)setPermissionDelegate:(nullable id<ISHPermissionRequestViewControllerDelegate>)permissionDelegate;
/**
 Seths the request object.
 @param request The request.
 */
- (void)setPermissionRequest:(nullable ISHPermissionRequest *)request;

@end
