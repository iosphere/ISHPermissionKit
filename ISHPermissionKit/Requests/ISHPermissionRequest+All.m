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
#import "ISHPermissionRequestPhotoLibrary.h"
#import "ISHPermissionRequestPhotoCamera.h"
#import "ISHPermissionRequestNotificationsLocal.h"
#import "ISHPermissionRequestAccount.h"
#import "ISHPermissionRequestHealth.h"
#import "ISHPermissionRequestAddressBook.h"
#import "ISHPermissionRequestEventStore.h"
#import "ISHPermissionRequest+Private.h"

@implementation ISHPermissionRequest (All)

+ (ISHPermissionRequest *)requestForCategory:(ISHPermissionCategory)category {
    ISHPermissionRequest *request = nil;
    
    switch (category) {
        case ISHPermissionCategoryLocationAlways:
        case ISHPermissionCategoryLocationWhenInUse: {
            request = [ISHPermissionRequestLocation new];
            break;
        }
            
        case ISHPermissionCategoryActivity:
            request = [ISHPermissionRequestMotion new];
            break;
        case ISHPermissionCategoryHealth:
            request = [ISHPermissionRequestHealth new];
            break;
            
        case ISHPermissionCategoryMicrophone:
            request = [ISHPermissionRequestMicrophone new];
            break;
            
        case ISHPermissionCategoryPhotoLibrary:
            request = [ISHPermissionRequestPhotoLibrary new];
            break;
            
        case ISHPermissionCategoryPhotoCamera:
            request = [ISHPermissionRequestPhotoCamera new];
            break;
            
        case ISHPermissionCategoryNotificationLocal:
            request = [ISHPermissionRequestNotificationsLocal new];
            break;
            
        case ISHPermissionCategorySocialFacebook:
        case ISHPermissionCategorySocialTwitter:
        case ISHPermissionCategorySocialSinaWeibo:
        case ISHPermissionCategorySocialTencentWeibo:
            request = [ISHPermissionRequestAccount new];
            break;
            
        case ISHPermissionCategoryAddressBook:
            request = [ISHPermissionRequestAddressBook new];
            break;
        case ISHPermissionCategoryEvents:
        case ISHPermissionCategoryReminders:
            request = [ISHPermissionRequestEventStore new];
            break;
    }
    
    [request setPermissionCategory:category];
    
    NSAssert(request, @"Request not implemented for category %@", @(category));
    return request;
}

@end
