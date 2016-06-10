//
//  ISHPermissionKitTests.m
//  ISHPermissionKitTests
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ISHPermissionKit/ISHPermissionRequest+All.h>

@interface ISHPermissionKitTests : XCTestCase

@end

@implementation ISHPermissionKitTests

- (void)testNonNilRequests {
    NSArray *allCategories = @[
                               @(ISHPermissionCategoryActivity),
                               @(ISHPermissionCategoryHealth),
                               @(ISHPermissionCategoryLocationAlways),
                               @(ISHPermissionCategoryLocationWhenInUse),
                               @(ISHPermissionCategoryMicrophone),
                               @(ISHPermissionCategoryPhotoLibrary),
                               @(ISHPermissionCategoryPhotoCamera),
                               @(ISHPermissionCategoryNotificationLocal),
                               @(ISHPermissionCategoryNotificationRemote),
                               @(ISHPermissionCategorySocialFacebook),
                               @(ISHPermissionCategorySocialTwitter),
                               @(ISHPermissionCategorySocialSinaWeibo),
                               @(ISHPermissionCategorySocialTencentWeibo),
                               @(ISHPermissionCategoryAddressBook),
                               @(ISHPermissionCategoryEvents),
                               @(ISHPermissionCategoryReminders),
                               ];

    for (NSNumber *boxedCategory in allCategories) {
        ISHPermissionCategory category = boxedCategory.unsignedIntegerValue;
        ISHPermissionRequest *req = [ISHPermissionRequest requestForCategory:category];
        XCTAssertNotNil(req, @"Request should not be nil for %@", ISHStringFromPermissionCategory(category));
    }
}

#if TARGET_OS_SIMULATOR
- (void)testUnsupportedOnSimulator {
    NSArray *allCategories = @[
                               @(ISHPermissionCategoryActivity),
                               @(ISHPermissionCategoryPhotoCamera),
                               ];

    for (NSNumber *boxedCategory in allCategories) {
        ISHPermissionCategory category = boxedCategory.unsignedIntegerValue;
        ISHPermissionRequest *req = [ISHPermissionRequest requestForCategory:category];
        ISHPermissionState state = [req permissionState];
        XCTAssertEqual(state, ISHPermissionStateUnsupported, @"Category should be unsupported on simulator: %@", ISHStringFromPermissionCategory(category));
    }
}
#endif

@end
