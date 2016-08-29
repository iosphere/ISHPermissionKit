//
//  AppDelegate.m
//  PermissionsTestApp
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "AppDelegate.h"
#import "SamplePermissionViewController.h"
#import "GrantedPermissionsViewController.h"

@import Accounts;
@import HealthKit;

@interface AppDelegate ()
@property (nonatomic, weak) GrantedPermissionsViewController *rootViewController;
@end

@implementation AppDelegate

+ (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupWindow];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentPermissionsIfNeeded];
    });

    return YES;
}

+ (NSArray<NSNumber *> *)requiredPermissions {
    // The demo app requests all supported permissions. Those that
    // require special capabilities have been commented out since
    // they require additional configuration in Xcode.
    return @[
             @(ISHPermissionCategoryActivity),

             // requires Health capability & entitlements
             // @(ISHPermissionCategoryHealth),

             // If you want to request both, the order is important,
             // as Always implies WhenInUse, too
             @(ISHPermissionCategoryLocationWhenInUse),
             @(ISHPermissionCategoryLocationAlways),

             @(ISHPermissionCategoryMicrophone),
             @(ISHPermissionCategoryPhotoLibrary),
             @(ISHPermissionCategoryModernPhotoLibrary),
             @(ISHPermissionCategoryPhotoCamera),
             @(ISHPermissionCategoryNotificationLocal),
             // requires Push capability & entitlements to actually work
             @(ISHPermissionCategoryNotificationRemote),

             @(ISHPermissionCategorySocialFacebook),
             @(ISHPermissionCategorySocialTwitter),
             @(ISHPermissionCategorySocialSinaWeibo),
             // TODO: alert cannot be presented
             @(ISHPermissionCategorySocialTencentWeibo),

             @(ISHPermissionCategoryAddressBook),
             @(ISHPermissionCategoryContacts),
             @(ISHPermissionCategoryEvents),
             @(ISHPermissionCategoryReminders),
             @(ISHPermissionCategoryMusicLibrary),

#ifdef NSFoundationVersionNumber_iOS_9_0
             // reqquires Siri capability & entitlements
             // @(ISHPermissionCategorySiri),
             @(ISHPermissionCategorySpeechRecognition),
             @(ISHPermissionCategoryUserNotification),
#endif
             ];
}

- (void)presentPermissionsIfNeeded {
    NSArray *permissions = [AppDelegate requiredPermissions];
    ISHPermissionsViewController *permissionsVC = [ISHPermissionsViewController permissionsViewControllerWithCategories:permissions dataSource:self];
    __weak GrantedPermissionsViewController *rootVC = self.rootViewController;
    [permissionsVC setCompletionBlock:^{
        [rootVC reloadPermissionsUsingDataSource:self];
    }];
    
    __weak ISHPermissionsViewController *weakPermissionsVC = permissionsVC;
    [permissionsVC setErrorBlock:^(ISHPermissionCategory category, NSError *error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:ISHStringFromPermissionCategory(category)
                                                                       message:error.localizedDescription
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Too bad" style:UIAlertActionStyleCancel handler:nil]];
        // if weakPermissionsVC still has a parent, present from there else present from root
        UIViewController *presentingVC = weakPermissionsVC.parentViewController ? weakPermissionsVC : rootVC;
        [presentingVC presentViewController:alert animated:nil completion:nil];
    }];

    if (permissionsVC) {
        [self.window.rootViewController presentViewController:permissionsVC animated:YES completion:nil];
    }
}

#pragma mark ISHPermissionsViewControllerDataSource

- (ISHPermissionRequestViewController *)permissionsViewController:(ISHPermissionsViewController *)vc requestViewControllerForCategory:(ISHPermissionCategory)category {
    return [SamplePermissionViewController new];
}

- (void)permissionsViewController:(ISHPermissionsViewController *)vc didConfigureRequest:(ISHPermissionRequest *)request {
    switch (request.permissionCategory) {
        case ISHPermissionCategoryHealth: {
            ISHPermissionRequestHealth *healthRequest = (ISHPermissionRequestHealth *)([request isKindOfClass:[ISHPermissionRequestHealth class]] ? request : nil);
            HKQuantityType *heartRate = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeartRate];
            healthRequest.objectTypesRead = [NSSet setWithObjects:heartRate, nil];
            healthRequest.objectTypesWrite = [NSSet setWithObjects:heartRate, nil];
            break;
        }

        case ISHPermissionCategoryNotificationLocal: {
            // the demo app only requests permissions for badges
            UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
            ISHPermissionRequestNotificationsLocal *localNotesRequest = (ISHPermissionRequestNotificationsLocal *)([request isKindOfClass:[ISHPermissionRequestNotificationsLocal class]] ? request : nil);
            [localNotesRequest setNotificationSettings:setting];
            break;
        }

        case ISHPermissionCategorySocialFacebook:
        case ISHPermissionCategorySocialTencentWeibo: {
            ISHPermissionRequestAccount *accountRequest = (ISHPermissionRequestAccount *)([request isKindOfClass:[ISHPermissionRequestAccount class]] ? request : nil);

            NSDictionary *options;
            if ([accountRequest.accountTypeIdentifier isEqualToString:ACAccountTypeIdentifierFacebook]) {
                options = @{
                            ACFacebookAppIdKey: @"YOUR-API-KEY",
                            ACFacebookPermissionsKey: @[@"email", @"user_about_me"],
                            ACFacebookAudienceKey: ACFacebookAudienceFriends,
                            };
            } else if ([accountRequest.accountTypeIdentifier isEqualToString:ACAccountTypeIdentifierTencentWeibo]) {
                options = @{
                            ACTencentWeiboAppIdKey: @"YOUR-API-KEY",
                            };
            }

            [accountRequest setOptions:options];
            break;
        }

        default:
            break;
    }
}

#pragma mark Important for local Notifications

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    [[NSNotificationCenter defaultCenter] postNotificationName:ISHPermissionNotificationApplicationDidRegisterUserNotificationSettings
                                                        object:self];
}

#pragma mark Boiler plate

- (void)setupWindow {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    GrantedPermissionsViewController *rootViewController = [GrantedPermissionsViewController new];
    [self.window setRootViewController:rootViewController];
    self.rootViewController = rootViewController;
    [self.window makeKeyAndVisible];
}

@end
