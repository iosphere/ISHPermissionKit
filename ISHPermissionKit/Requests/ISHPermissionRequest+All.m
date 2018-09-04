//
//  ISHPermissionRequest+All.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 26.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequest+All.h"
#import "ISHPermissionRequestLocation.h"
#import "ISHPermissionRequestMotion.h"
#import "ISHPermissionRequestMicrophone.h"
#import "ISHPermissionRequestModernPhotoLibrary.h"
#import "ISHPermissionRequestPhotoCamera.h"
#import "ISHPermissionRequestNotificationsLocal.h"
#import "ISHPermissionRequestNotificationsRemote.h"
#import "ISHPermissionRequestUserNotification.h"
#import "ISHPermissionRequestAccount.h"
#import "ISHPermissionRequestHealth.h"
#import "ISHPermissionRequestContacts.h"
#import "ISHPermissionRequestEventStore.h"
#import "ISHPermissionRequest+Private.h"
#import "ISHPermissionRequestSiri.h"
#import "ISHPermissionRequestSpeechRecognition.h"
#import "ISHPermissionRequestMusicLibrary.h"

@interface ISHPermissionRequest (Private)
- (void)setPermissionCategory:(ISHPermissionCategory)category;
@end

@implementation ISHPermissionRequest (All)

+ (ISHPermissionRequest *)requestForCategory:(ISHPermissionCategory)category {
    ISHPermissionRequest *request = nil;
    
    switch (category) {
#ifdef ISHPermissionRequestLocationEnabled
        case ISHPermissionCategoryLocationAlways:
        case ISHPermissionCategoryLocationWhenInUse:
            request = [ISHPermissionRequestLocation new];
            break;
#endif

#ifdef ISHPermissionRequestMotionEnabled
        case ISHPermissionCategoryActivity:
            request = [ISHPermissionRequestMotion new];
            break;
#endif

#ifdef ISHPermissionRequestHealthKitEnabled
        case ISHPermissionCategoryHealth:
            request = [ISHPermissionRequestHealth new];
            break;
#endif

#ifdef ISHPermissionRequestMicrophoneEnabled
        case ISHPermissionCategoryMicrophone:
            request = [ISHPermissionRequestMicrophone new];
            break;
#endif

#ifdef ISHPermissionRequestPhotoLibraryEnabled
        case ISHPermissionCategoryModernPhotoLibrary:
            request = [ISHPermissionRequestModernPhotoLibrary new];
            break;
#endif

#ifdef ISHPermissionRequestCameraEnabled
        case ISHPermissionCategoryPhotoCamera:
            request = [ISHPermissionRequestPhotoCamera new];
            break;
#endif

#ifdef ISHPermissionRequestNotificationsEnabled
        case ISHPermissionCategoryNotificationLocal:
            request = [ISHPermissionRequestNotificationsLocal new];
            break;
            
        case ISHPermissionCategoryNotificationRemote:
            request = [ISHPermissionRequestNotificationsRemote new];
            break;
#endif

#ifdef ISHPermissionRequestSocialAccountsEnabled
        case ISHPermissionCategorySocialFacebook:
        case ISHPermissionCategorySocialTwitter:
        case ISHPermissionCategorySocialSinaWeibo:
        case ISHPermissionCategorySocialTencentWeibo:
            request = [ISHPermissionRequestAccount new];
            break;
#endif

#ifdef ISHPermissionRequestContactsEnabled
        case ISHPermissionCategoryContacts:
            request = [ISHPermissionRequestContacts new];
            break;
#endif

#ifdef ISHPermissionRequestCalendarEnabled
        case ISHPermissionCategoryEvents:
            request = [ISHPermissionRequestEventStore new];
            break;
#endif

#ifdef ISHPermissionRequestRemindersEnabled
        case ISHPermissionCategoryReminders:
            request = [ISHPermissionRequestEventStore new];
            break;
#endif

#ifdef ISHPermissionRequestMusicLibraryEnabled
        case ISHPermissionCategoryMusicLibrary:
            request = [ISHPermissionRequestMusicLibrary new];
            break;
#endif

#ifdef ISHPermissionRequestSiriEnabled
        case ISHPermissionCategorySiri:
            request = [ISHPermissionRequestSiri new];
            break;
#endif

#ifdef ISHPermissionRequestSpeechEnabled
        case ISHPermissionCategorySpeechRecognition:
            request = [ISHPermissionRequestSpeechRecognition new];
            break;
#endif

#ifdef ISHPermissionRequestNotificationsEnabled
        case ISHPermissionCategoryUserNotification:
            request = [ISHPermissionRequestUserNotification new];
            break;
#endif

        case ISHPermissionCategoryInvalid:
            break;
    }
    
    [request setPermissionCategory:category];
    
    NSAssert(request, @"Request not implemented for category %@", @(category));

    // fall back to a dummy request of ISHPermissionCategoryInvalid to satisfy nonnull promise
    return request ?: [ISHPermissionRequest new];
}

@end
