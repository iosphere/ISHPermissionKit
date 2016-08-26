//
//  ISHPermissionCategory.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//


/**
 *  Permission categories describe types of permissions on iOS.
 *  Each is related to a specific PermissionRequest.
 *  @note Values assigned to each category must not be changed, as 
 *        they may have been persisted on user devices.
 */
typedef NS_ENUM(NSUInteger, ISHPermissionCategory) {
    /**
     *  Permission required for step counting and motion activity queries. 
     *
     *  The app must also provide a localized NSMotionUsageDescription
     *  in the Info PLIST.
     *
     *  @sa Reference documentation for CoreMotion.
     */
    ISHPermissionCategoryActivity = 1000,
    
    /**
     *  Permission required to use HealthKit data.
     *
     *  Make sure to comply with section 5.1 of the review guidelines.
     *  Use the `ISHPermissionKitLib+HealthKit` static library or
     *  the `ISHPermissionKit+HealthKit` framework if you want to use
     *  this permission category.
     *
     *  The app must also provide a localized NSHealthShareUsageDescription
     *  in the Info PLIST if you read HealthKit data, and
     *  NSHealthUpdateUsageDescription to write to HealthKit.
     *
     *  @note: The Health app and HealthKit are not available on iPad.
     *  Using this category on iPad will fail gracefully by always
     *  returning the state ISHPermissionStateUnsupported.
     *
     *  @sa README.md for further reading on HealthKit integration.
     */
    ISHPermissionCategoryHealth = 2000,
    
    /**
     *  Permission required to use the user's location at any time,
     *  including monitoring for regions, visits, or significant location changes.
     *
     *  If you want to request both Always and WhenInUse, you should ask for 
     *  WhenInUse first. You can do so by passing both categories to the
     *  ISHPermissionsViewController with WhenInUse before Always.
     *
     *  The app must also provide a localized NSLocationAlwaysUsageDescription
     *  in the Info PLIST.
     *
     *  @sa ISHPermissionCategoryLocationWhenInUse
     */
    ISHPermissionCategoryLocationAlways = 3100,
    /**
     *  Permission required to use the user's location only when your app
     *  is visible to them.
     *
     *  The app must also provide a localized NSLocationWhenInUseUsageDescription
     *  in the Info PLIST.
     *
     *  @sa ISHPermissionCategoryLocationAlways
     */
    ISHPermissionCategoryLocationWhenInUse = 3200,
    
    /**
     *  Permission required to record the user's microphone input.
     *
     *  The app must also provide a localized NSMicrophoneUsageDescription
     *  in the Info PLIST.
     */
    ISHPermissionCategoryMicrophone = 4000,
    
    /**
     *  Permission required to access the user's photo library.
     *
     *  Deprecated from iOS 9 as it uses ALAssetsLibrary
     *  internally.
     *
     *  The app must also provide a localized NSPhotoLibraryUsageDescription
     *  in the Info PLIST.
     *
     *  @sa ISHPermissionCategoryModernPhotoLibrary
     */
    ISHPermissionCategoryPhotoLibrary NS_ENUM_DEPRECATED_IOS(7.0, 9.0, "Use ISHPermissionCategoryModernPhotoLibrary") = 5000,
    /**
     *  Permission required to access the user's photo library.
     *
     *  Uses PHPhotoLibrary APIs.
     *
     *  The app must also provide a localized NSPhotoLibraryUsageDescription
     *  in the Info PLIST.
     */
    ISHPermissionCategoryModernPhotoLibrary NS_ENUM_AVAILABLE_IOS(8_0) = 5050,
    /**
     *  Permission required to access the user's camera.
     *
     *  The app must also provide a localized NSCameraUsageDescription
     *  in the Info PLIST.
     */
    ISHPermissionCategoryPhotoCamera = 5100,
    
    /**
     *  Permission required to schedule local notifications.
     *
     *  @note Requests for this permission might require further 
     *        configuration via the ISHPermissionsViewControllerDataSource.
     *
     *  @warning Your app delegate will need to implement the following lines:
     *  @code
     *  - (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
     *       ISHPermissionPostNotificationDidRegisterUserNotificationSettings(self);
     *  }
     *  @endcode
     */
    ISHPermissionCategoryNotificationLocal NS_ENUM_DEPRECATED_IOS(8.0, 10.0, "Use ISHPermissionCategoryUserNotification") = 6100,
    
    /**
     *  Permission required to receive user-facing remote notifications.
     *
     *  @note Requests for this permission might require further
     *        configuration via the ISHPermissionsViewControllerDataSource to notificationSettings.
     *        By default this request asks for [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert categories:nil];
     *
     *  This only requests permission to present user-facing notifications. To register for remote
     *  notifications (without permission, these are delivered silently) you will need to call 
     *  the following method in your own code:
     *  @code
     *      [[UIApplication sharedApplication] registerForRemoteNotifications];
     *  @endcode
     *
     *  @warning Your app delegate will need to implement the following lines:
     *  @code
     *  - (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
     *       ISHPermissionPostNotificationDidRegisterUserNotificationSettings(self);
     *  }
     *  @endcode
     */
    ISHPermissionCategoryNotificationRemote NS_ENUM_DEPRECATED_IOS(8.0, 10.0, "Use ISHPermissionCategoryUserNotification") = 6200,
    
    /**
     *  Permission required to access the user's Facebook accounts.
     *  @note Requests for this permission require further
     *        configuration via the ISHPermissionsViewControllerDataSource.
     *        The request will require an options dictionary including, e.g., ACFacebookAppIdKey.
     */
    ISHPermissionCategorySocialFacebook = 7100,
    /**
     *  Permission required to access the user's Twitter accounts.
     */
    ISHPermissionCategorySocialTwitter = 7110,
    /**
     *  Permission required to access the user's SinaWeibo accounts.
     */
    ISHPermissionCategorySocialSinaWeibo = 7120,
    /**
     *  Permission required to access the user's TencentWeibo accounts.
     */
    ISHPermissionCategorySocialTencentWeibo = 7130,
    
    /**
     *  Permission required to access the user's contacts.
     *
     *  The app must also provide a localized NSContactsUsageDescription
     *  in the Info PLIST.
     */
    ISHPermissionCategoryAddressBook NS_ENUM_DEPRECATED_IOS(7.0, 9.0, "Use ISHPermissionCategoryContacts") = 8100,
    /**
     *  Permission required to access the user's contacts on modern
     *  systems, using the Contacts framework.
     *
     *  The app must also provide a localized NSContactsUsageDescription
     *  in the Info PLIST.
     */
    ISHPermissionCategoryContacts NS_ENUM_AVAILABLE_IOS(9_0) = 8500,
    
    /**
     *  Permission required to access the user's calendar.
     *
     *  The app must also provide a localized NSCalendarsUsageDescription
     *  in the Info PLIST.
     */
    ISHPermissionCategoryEvents = 8200,
    /**
     *  Permission required to access the user's reminders.
     *
     *  The app must also provide a localized NSRemindersUsageDescription
     *  in the Info PLIST.
     */
    ISHPermissionCategoryReminders = 8250,

#ifdef NSFoundationVersionNumber_iOS_9_0
    /**
     *  Permission required for Siri to access your app's data.
     *
     *  To use this category, you must also enable the respective
     *  capability in your app target, else your app will crash.
     *
     *  The app must also provide a localized NSSiriUsageDescription
     *  in the Info PLIST.
     */
    ISHPermissionCategorySiri NS_ENUM_AVAILABLE_IOS(10_0) = 9000,

    /**
     *  Permission required to perform speech recognition, which sends
     *  user data to Apple's servers.
     *
     *  The app must also provide a localized NSSpeechRecognitionUsageDescription
     *  in the Info PLIST.
     */
    ISHPermissionCategorySpeechRecognition NS_ENUM_AVAILABLE_IOS(10_0) = 10000,

    /**
     *  Modern way to request permission to local and remote notifications.
     *
     *  While it is technically possible to request both the old
     *  ISHPermissionCategoryNotificationLocal/ISHPermissionCategoryNotificationRemote
     *  permissions and this new category (which will be skipped on
     *  unsupported runtimes), we encourage you to check the system
     *  capabilities in your app and request only the categories
     *  that are appropriate for the current runtime. Otherwise,
     *  users on new platforms (which support the old and new APIs)
     *  may be prompted twice when they choose "Later".
     *
     *  Allows configuration by the data source.
     *
     *  @sa ISHPermissionRequestUserNotification
     */
    ISHPermissionCategoryUserNotification NS_ENUM_AVAILABLE_IOS(10_0) = 6500,
#endif

    /**
     *  Permission required to access the user's music library, including,
     *  but not limited to the user's songs and lists from Apple Music.
     *
     *  The app must also provide a localized NSAppleMusicUsageDescription
     *  in the Info PLIST.
     */
    ISHPermissionCategoryMusicLibrary NS_ENUM_AVAILABLE_IOS(9.3) = 11000,
};


/**
 *  @param category A value from the ISHPermissionCategory enum.
 *
 *  @return A string representation of an ISHPermissionCategory enum value. (Used mainly for debugging).
 */
static inline NSString * _Nonnull ISHStringFromPermissionCategory(ISHPermissionCategory category) {
    switch (category) {
        case ISHPermissionCategoryActivity:
            return @"ISHPermissionCategoryActivity";
        case ISHPermissionCategoryHealth:
            return @"ISHPermissionCategoryHealth";
        case ISHPermissionCategoryLocationAlways:
            return @"ISHPermissionCategoryLocationAlways";
        case ISHPermissionCategoryLocationWhenInUse:
            return @"ISHPermissionCategoryLocationWhenInUse";
        case ISHPermissionCategoryMicrophone:
            return @"ISHPermissionCategoryMicrophone";
        case ISHPermissionCategoryPhotoLibrary:
            return @"ISHPermissionCategoryPhotoLibrary";
        case ISHPermissionCategoryModernPhotoLibrary:
            return @"ISHPermissionCategoryModernPhotoLibrary";
        case ISHPermissionCategoryPhotoCamera:
            return @"ISHPermissionCategoryPhotoCamera";
        case ISHPermissionCategoryNotificationLocal:
            return @"ISHPermissionCategoryNotificationLocal";
        case ISHPermissionCategoryNotificationRemote:
            return @"ISHPermissionCategoryNotificationRemote";
        case ISHPermissionCategorySocialFacebook:
            return @"ISHPermissionCategorySocialFacebook";
        case ISHPermissionCategorySocialTwitter:
            return @"ISHPermissionCategorySocialTwitter";
        case ISHPermissionCategorySocialSinaWeibo:
            return @"ISHPermissionCategorySocialSinaWeibo";
        case ISHPermissionCategorySocialTencentWeibo:
            return @"ISHPermissionCategorySocialTencentWeibo";
        case ISHPermissionCategoryAddressBook:
            return @"ISHPermissionCategoryAddressBook";
        case ISHPermissionCategoryContacts:
            return @"ISHPermissionCategoryContacts";
        case ISHPermissionCategoryEvents:
            return @"ISHPermissionCategoryEvents";
        case ISHPermissionCategoryReminders:
            return @"ISHPermissionCategoryReminders";
        case ISHPermissionCategoryMusicLibrary:
            return @"ISHPermissionCategoryMusicLibrary";
#ifdef NSFoundationVersionNumber_iOS_9_0
        case ISHPermissionCategorySiri:
            return @"ISHPermissionCategorySiri";
        case ISHPermissionCategorySpeechRecognition:
            return @"ISHPermissionCategorySpeechRecognition";
        case ISHPermissionCategoryUserNotification:
            return @"ISHPermissionCategoryUserNotification";
#endif
    }

    NSLog(@"Invalid category: %lu", (unsigned long)category);
    return @"";
}
