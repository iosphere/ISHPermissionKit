//
//  ISHPermissionCategory.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

/**
 *  Permission categories describe types of permissions on iOS.
 *  Each is related to a specific ISHPermissionRequest.
 *
 *  To prevent having unused auto-linked frameworks and privacy-
 *  sensitive APIs in your app, each category must be explicitly
 *  enabled by a build flag. Some frameworks have additional 
 *  requirements. Please read the documentation for each category
 *  carefully to avoid App Store rejections.
 *
 *  @note Values assigned to each category must not be changed, as
 *  they may have been persisted on user devices.
 */
typedef NS_ENUM(NSUInteger, ISHPermissionCategory) {
    /**
     *  Invalid category. Should be treated as error case.
     */
    ISHPermissionCategoryInvalid = 0,

#ifdef ISHPermissionRequestMotionEnabled
    /**
     *  Permission required for accessing the accelerometer, step
     *  counting, and motion activity queries.
     *
     *  The app must also provide a localized NSMotionUsageDescription
     *  in the Info PLIST. Please consult the app review guidelines 
     *  for special requirements for apps that access motion data,
     *  specifically section 5.1 (Privacy).
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestMotionEnabled. This will link CoreMotion.
     */
    ISHPermissionCategoryActivity = 1000,
#endif

#ifdef ISHPermissionRequestHealthKitEnabled
    /**
     *  Permission required to use HealthKit data, incl. workouts,
     *  heart rates, and activity distances.
     *
     *  The app must also provide a localized NSHealthShareUsageDescription
     *  in the Info PLIST if you read HealthKit data, and
     *  NSHealthUpdateUsageDescription to write to HealthKit. Please consult 
     *  the app review guidelines for special requirements for apps that 
     *  access health data, specifically section 5.1 (Privacy).
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestHealthKitEnabled. This will link HealthKit.
     *
     *  @note: The Health app and HealthKit are not available on iPad.
     *  Using this category on iPad will fail gracefully by always
     *  returning the state ISHPermissionStateUnsupported.
     */
    ISHPermissionCategoryHealth = 2000,
#endif
    
#ifdef ISHPermissionRequestLocationEnabled
    /**
     *  Permission required to use the user's location at any time,
     *  including monitoring for regions, visits, or significant location 
     *  changes.
     *
     *  If you want to request both Always and WhenInUse, you should ask for 
     *  WhenInUse first. You can do so by passing both categories to the
     *  ISHPermissionsViewController with WhenInUse before Always.
     *
     *  The app must also provide a localized NSLocationAlwaysUsageDescription
     *  in the Info PLIST. Please consult the app review guidelines for special
     *  requirements for apps that access location data, specifically section
     *  5.1 (Privacy).
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestLocationEnabled. This will link CoreLocation.
     *
     *  @sa ISHPermissionCategoryLocationWhenInUse
     */
    ISHPermissionCategoryLocationAlways = 3100,
    /**
     *  Permission required to start accessing the user's location only when
     *  your app is visible to them. Continued use in the background will
     *  display a blue status bar with a note that your app is still accessing
     *  the location.
     *
     *  The app must also provide a localized NSLocationWhenInUseUsageDescription
     *  in the Info PLIST. Please consult the app review guidelines for special
     *  requirements for apps that access location data, specifically section
     *  5.1 (Privacy).
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestLocationEnabled. This will link CoreLocation.
     *
     *  @sa ISHPermissionCategoryLocationAlways
     */
    ISHPermissionCategoryLocationWhenInUse = 3200,
#endif

#ifdef ISHPermissionRequestMicrophoneEnabled
    /**
     *  Permission required to record the user's microphone input.
     *
     *  The app must also provide a localized NSMicrophoneUsageDescription
     *  in the Info PLIST.
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestMicrophoneEnabled. This will link AVFoundation.
     */
    ISHPermissionCategoryMicrophone = 4000,
#endif

#ifdef ISHPermissionRequestPhotoLibraryEnabled
    /**
     *  Permission required to access the user's photo library.
     *
     *  Uses PHPhotoLibrary APIs.
     *
     *  The app must also provide a localized NSPhotoLibraryUsageDescription
     *  in the Info PLIST.
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestPhotoLibraryEnabled. This will link the
     *  Photos frameworks.
     */
    ISHPermissionCategoryModernPhotoLibrary = 5050,
#endif

#ifdef ISHPermissionRequestCameraEnabled
    /**
     *  Permission required to access the user's camera.
     *
     *  The app must also provide a localized NSCameraUsageDescription
     *  in the Info PLIST.
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestCameraEnabled. This will link AVFoundation.
     */
    ISHPermissionCategoryPhotoCamera = 5100,
#endif

#ifdef ISHPermissionRequestNotificationsEnabled
    /**
     *  Permission required to schedule local notifications.
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestNotificationsEnabled. This will link UIKit and
     *  the UserNotification framework.
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
     *
     *  @sa ISHPermissionCategoryUserNotification
     */
    ISHPermissionCategoryNotificationLocal NS_ENUM_DEPRECATED_IOS(8.0, 10.0, "Use ISHPermissionCategoryUserNotification") = 6100,
    
    /**
     *  Permission required to receive user-facing remote notifications.
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestNotificationsEnabled. This will link UIKit and
     *  the UserNotification framework.
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
     *
     *  @sa ISHPermissionCategoryUserNotification
     */
    ISHPermissionCategoryNotificationRemote NS_ENUM_DEPRECATED_IOS(8.0, 10.0, "Use ISHPermissionCategoryUserNotification") = 6200,
#endif

#ifdef ISHPermissionRequestSocialAccountsEnabled
    /**
     *  Permission required to access the user's Facebook accounts.
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestSocialAccountsEnabled. This will link the
     *  Accounts framework.
     *
     *  @note Requests for this permission require further
     *        configuration via the ISHPermissionsViewControllerDataSource.
     *        The request will require an options dictionary including, e.g., 
     *        ACFacebookAppIdKey.
     */
    ISHPermissionCategorySocialFacebook NS_ENUM_DEPRECATED_IOS(6.0, 11.0, "Social framework has been removed") = 7100,
    /**
     *  Permission required to access the user's Twitter accounts.
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestSocialAccountsEnabled. This will link the
     *  Accounts framework.
     */
    ISHPermissionCategorySocialTwitter NS_ENUM_DEPRECATED_IOS(6.0, 11.0, "Social framework has been removed") = 7110,
    /**
     *  Permission required to access the user's SinaWeibo accounts.
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestSocialAccountsEnabled. This will link the
     *  Accounts framework.
     */
    ISHPermissionCategorySocialSinaWeibo NS_ENUM_DEPRECATED_IOS(6.0, 11.0, "Social framework has been removed") = 7120,
    /**
     *  Permission required to access the user's TencentWeibo accounts.
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestSocialAccountsEnabled. This will link the
     *  Accounts framework.
     */
    ISHPermissionCategorySocialTencentWeibo NS_ENUM_DEPRECATED_IOS(6.0, 11.0, "Social framework has been removed") = 7130,
#endif

#ifdef ISHPermissionRequestContactsEnabled
    /**
     *  Permission required to access the user's contacts on modern
     *  systems, using the Contacts framework.
     *
     *  The app must also provide a localized NSContactsUsageDescription
     *  in the Info PLIST. Please consult the app review guidelines for
     *  special requirements for apps that access contacts, specifically
     *  section 5.1 (Privacy).
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestContactsEnabled. This will link the Contacts
     *  framework.
     */
    ISHPermissionCategoryContacts = 8500,
#endif

#ifdef ISHPermissionRequestCalendarEnabled
    /**
     *  Permission required to access the user's calendar.
     *
     *  The app must also provide a localized NSCalendarsUsageDescription
     *  in the Info PLIST. Please consult the app review guidelines for
     *  special requirements for apps that access calendar information,
     *  specifically section 5.1 (Privacy).
     *  
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestCalendarEnabled. This will link EventKit.
     */
    ISHPermissionCategoryEvents = 8200,
#endif

#ifdef ISHPermissionRequestRemindersEnabled
    /**
     *  Permission required to access the user's reminders.
     *
     *  The app must also provide a localized NSRemindersUsageDescription
     *  in the Info PLIST. Please consult the app review guidelines for
     *  special requirements for apps that access reminders, specifically
     *  section 5.1 (Privacy).
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestRemindersEnabled. This will link EventKit.
     */
    ISHPermissionCategoryReminders = 8250,
#endif

#ifdef ISHPermissionRequestSiriEnabled
    /**
     *  Permission required for Siri to access your app's data.
     *
     *  To use this category, you must also enable the respective
     *  capability in your app target, else your app will crash.
     *
     *  The app must also provide a localized NSSiriUsageDescription
     *  in the Info PLIST.
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestSiriEnabled. This will link the Intents
     *  framework.
     */
    ISHPermissionCategorySiri = 9000,
#endif

#ifdef ISHPermissionRequestSpeechEnabled
    /**
     *  Permission required to perform speech recognition, which sends
     *  user data to Apple's servers.
     *
     *  The app must also provide a localized NSSpeechRecognitionUsageDescription
     *  in the Info PLIST.
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestSpeechEnabled. This will link the Speech
     *  framework.
     */
    ISHPermissionCategorySpeechRecognition = 10000,
#endif

#ifdef ISHPermissionRequestNotificationsEnabled
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
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestNotificationsEnabled. This will link UIKit and
     *  the UserNotification framework.
     */
    ISHPermissionCategoryUserNotification = 6500,
#endif

#ifdef ISHPermissionRequestMusicLibraryEnabled
    /**
     *  Permission required to access the user's music library, including,
     *  but not limited to the user's songs and lists from Apple Music.
     *
     *  The app must also provide a localized NSAppleMusicUsageDescription
     *  in the Info PLIST.
     *
     *  To enable this category, you must set the preprocessor flag
     *  ISHPermissionRequestMusicLibraryEnabled. This will link the MediaPlayer
     *  framework.
     */
    ISHPermissionCategoryMusicLibrary = 11000,
#endif
};

/**
 *  @param category A value from the ISHPermissionCategory enum.
 *
 *  @return A string representation of an ISHPermissionCategory enum value. (Used mainly for debugging).
 */
static inline NSString * _Nonnull ISHStringFromPermissionCategory(ISHPermissionCategory category) {
    switch (category) {
#ifdef ISHPermissionRequestMotionEnabled
        case ISHPermissionCategoryActivity:
            return @"ISHPermissionCategoryActivity";
#endif

#ifdef ISHPermissionRequestHealthKitEnabled
        case ISHPermissionCategoryHealth:
            return @"ISHPermissionCategoryHealth";
#endif

#ifdef ISHPermissionRequestLocationEnabled
        case ISHPermissionCategoryLocationAlways:
            return @"ISHPermissionCategoryLocationAlways";
        case ISHPermissionCategoryLocationWhenInUse:
            return @"ISHPermissionCategoryLocationWhenInUse";
#endif

#ifdef ISHPermissionRequestMicrophoneEnabled
        case ISHPermissionCategoryMicrophone:
            return @"ISHPermissionCategoryMicrophone";
#endif

#ifdef ISHPermissionRequestPhotoLibraryEnabled
        case ISHPermissionCategoryModernPhotoLibrary:
            return @"ISHPermissionCategoryModernPhotoLibrary";
#endif

#ifdef ISHPermissionRequestCameraEnabled
        case ISHPermissionCategoryPhotoCamera:
            return @"ISHPermissionCategoryPhotoCamera";
#endif

#ifdef ISHPermissionRequestNotificationsEnabled
        case ISHPermissionCategoryNotificationLocal:
            return @"ISHPermissionCategoryNotificationLocal";
        case ISHPermissionCategoryNotificationRemote:
            return @"ISHPermissionCategoryNotificationRemote";
#endif

#ifdef ISHPermissionRequestSocialAccountsEnabled
        case ISHPermissionCategorySocialFacebook:
            return @"ISHPermissionCategorySocialFacebook";
        case ISHPermissionCategorySocialTwitter:
            return @"ISHPermissionCategorySocialTwitter";
        case ISHPermissionCategorySocialSinaWeibo:
            return @"ISHPermissionCategorySocialSinaWeibo";
        case ISHPermissionCategorySocialTencentWeibo:
            return @"ISHPermissionCategorySocialTencentWeibo";
#endif

#ifdef ISHPermissionRequestContactsEnabled
        case ISHPermissionCategoryContacts:
            return @"ISHPermissionCategoryContacts";
#endif

#ifdef ISHPermissionRequestCalendarEnabled
        case ISHPermissionCategoryEvents:
            return @"ISHPermissionCategoryEvents";
#endif

#ifdef ISHPermissionRequestRemindersEnabled
        case ISHPermissionCategoryReminders:
            return @"ISHPermissionCategoryReminders";
#endif

#ifdef ISHPermissionRequestMusicLibraryEnabled
        case ISHPermissionCategoryMusicLibrary:
            return @"ISHPermissionCategoryMusicLibrary";
#endif

#ifdef ISHPermissionRequestSiriEnabled
        case ISHPermissionCategorySiri:
            return @"ISHPermissionCategorySiri";
#endif

#ifdef ISHPermissionRequestSpeechEnabled
        case ISHPermissionCategorySpeechRecognition:
            return @"ISHPermissionCategorySpeechRecognition";
#endif

#ifdef ISHPermissionRequestNotificationsEnabled
        case ISHPermissionCategoryUserNotification:
            return @"ISHPermissionCategoryUserNotification";
#endif

        case ISHPermissionCategoryInvalid:
            break;
    }

    NSLog(@"Invalid category: %lu", (unsigned long)category);
    return @"";
}
