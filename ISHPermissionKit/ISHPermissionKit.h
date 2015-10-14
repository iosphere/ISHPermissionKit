//
//  ISHPermissionKit.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for ISHPermissionKit.
FOUNDATION_EXPORT double ISHPermissionKitVersionNumber;

//! Project version string for ISHPermissionKit.
FOUNDATION_EXPORT const unsigned char ISHPermissionKitVersionString[];

// Public module headers
#import <ISHPermissionKit/ISHPermissionsViewController.h>
#import <ISHPermissionKit/ISHPermissionRequestViewController.h>
#import <ISHPermissionKit/ISHPermissionCategory.h>
#import <ISHPermissionKit/ISHPermissionRequest.h>
#import <ISHPermissionKit/ISHPermissionRequest+All.h>

// Public module headers: Special request subclasses that might require further configuration
#import <ISHPermissionKit/ISHPermissionRequestNotificationsLocal.h>
#import <ISHPermissionKit/ISHPermissionRequestNotificationsRemote.h>
#import <ISHPermissionKit/ISHPermissionRequestAccount.h>
#import <ISHPermissionKit/ISHPermissionRequestHealth.h>
