//
//  ISHPermissionRequest+All.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 26.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequest+All.h"
#import "ISHPermissionRequestLocation.h"

@implementation ISHPermissionRequest (All)

+ (ISHPermissionRequest *)requestForCategory:(ISHPermissionCategory)category {
    switch (category) {
        case ISHPermissionCategoryLocationAlways:
        case ISHPermissionCategoryLocationWhenInUse: {
            ISHPermissionRequestLocation *request = [ISHPermissionRequestLocation new];
            [request setPermissionCategory:category];
            return request;
        }
        default:
            break;
    }

    NSAssert(false, @"Request not implemented for category %@", @(category));
    return nil;
}

@end
