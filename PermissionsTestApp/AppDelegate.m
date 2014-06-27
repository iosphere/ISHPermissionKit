//
//  AppDelegate.m
//  PermissionsTestApp
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "AppDelegate.h"
#import "SamplePermissionViewController.h"
#import <ISHPermissionKit/ISHPermissionKit.h>

@interface AppDelegate () <ISHPermissionsViewControllerDatasource>
        
@end

@implementation AppDelegate
            

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *rootVC = [UIViewController new];
    [rootVC.view setBackgroundColor:[UIColor greenColor]];
    [self.window setRootViewController:rootVC];
    [self.window makeKeyAndVisible];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *permissions = @[ @(ISHPermissionCategoryLocationWhenInUse), @(ISHPermissionCategoryActivity) , @(ISHPermissionCategoryMicrophone), @(ISHPermissionCategoryPhotoLibrary) ];
        ISHPermissionsViewController *perm = [ISHPermissionsViewController permissionsViewControllerWithCategories:permissions];
        if (perm) {
            [perm setDataSource:self];
            [rootVC presentViewController:perm animated:NO completion:nil];
        }
    });

    
    return YES;
}

#pragma mark ISHPermissionsViewControllerDatasource

- (ISHPermissionRequestViewController *)permissionsViewController:(ISHPermissionsViewController *)vc requestViewControllerForCategory:(ISHPermissionCategory)category {
    return [SamplePermissionViewController new];
}

@end
