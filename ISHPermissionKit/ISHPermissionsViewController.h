//
//  ISHPermissionsViewController.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ISHPermissionKit/ISHPermissionRequestViewController.h>
#import <ISHPermissionKit/ISHPermissionCategory.h>

@class ISHPermissionsViewController;

@protocol ISHPermissionsViewControllerDatasource <NSObject>
- (ISHPermissionRequestViewController *)permissionsViewController:(ISHPermissionsViewController *)vc requestViewControllerForCategory:(ISHPermissionCategory)category;
/*
FUTURE IDEAS
 @optional
- (ISHPermissionRequestViewController *)permissionsViewController:(ISHPermissionsViewController *)vc didChangeToState:(ISHPermissionState)state forCategory:(ISHPermissionCategory)category;
*/
@end

@protocol ISHPermissionsViewControllerDelegate <NSObject>

- (ISHPermissionRequestViewController *)permissionsViewControllerDidComplete:(ISHPermissionsViewController *)vc;

@end

@interface ISHPermissionsViewController : UIViewController
+ (instancetype)permissionsViewControllerWithCategories:(NSArray *)categories;
@property (nonatomic, weak) id <ISHPermissionsViewControllerDatasource> dataSource;
@property (nonatomic, weak) id <ISHPermissionsViewControllerDelegate> delegate;
@end
