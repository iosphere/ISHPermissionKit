//
//  ISHPermissionKitTests.m
//  ISHPermissionKitTests
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <ISHPermissionKit/ISHPermissionRequest+All.h>
#import "ISHPermissionRequest+Private.h"

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
                               @(ISHPermissionCategoryModernPhotoLibrary),
                               @(ISHPermissionCategoryPhotoCamera),
                               @(ISHPermissionCategoryNotificationLocal),
                               @(ISHPermissionCategoryNotificationRemote),
                               @(ISHPermissionCategorySocialFacebook),
                               @(ISHPermissionCategorySocialTwitter),
                               @(ISHPermissionCategorySocialSinaWeibo),
                               @(ISHPermissionCategorySocialTencentWeibo),
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

- (void)testExternalErrorValidation {
    NSString *errorDomain = @"randomain";
    NSInteger denied = 1;
    NSSet *deniedSet = [NSSet setWithObject:@(denied)];
    NSError *userDeniedError = [NSError errorWithDomain:errorDomain code:denied userInfo:nil];
    NSError *externalError = [NSError errorWithDomain:errorDomain code:123 userInfo:nil];
    NSError *otherDomainError = [NSError errorWithDomain:@"otherDomain" code:denied userInfo:nil];

    XCTAssertNil([ISHPermissionRequest externalErrorForError:nil validationDomain:errorDomain denialCodes:deniedSet]);
    XCTAssertNil([ISHPermissionRequest externalErrorForError:userDeniedError validationDomain:errorDomain denialCodes:deniedSet]);
    XCTAssertNil([ISHPermissionRequest externalErrorForError:otherDomainError validationDomain:errorDomain denialCodes:deniedSet]);
    XCTAssertEqualObjects([ISHPermissionRequest externalErrorForError:externalError validationDomain:errorDomain denialCodes:deniedSet], externalError);
}

@end
