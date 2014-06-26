//
//  ISHPermissionCategory.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

typedef NS_ENUM(NSUInteger, ISHPermissionCategory) {
    ISHPermissionCategoryActivity = 1000,
    ISHPermissionCategoryHealth = 2000,
    ISHPermissionCategoryLocationAlways = 3100,
    ISHPermissionCategoryLocationWhenInUse = 3200,
    ISHPermissionCategoryBluetooth = 4000,
};

static inline NSString *ISHStringFromPermissionCategory(ISHPermissionCategory category) {
    switch (category) {
        case ISHPermissionCategoryActivity:
            return @"ISHPermissionCategoryActivity";
        case ISHPermissionCategoryHealth:
            return @"ISHPermissionCategoryHealth";
        case ISHPermissionCategoryLocationAlways:
            return @"ISHPermissionCategoryLocationAlways";
        case ISHPermissionCategoryLocationWhenInUse:
            return @"ISHPermissionCategoryLocationWhenInUse";
        case ISHPermissionCategoryBluetooth:
            return @"ISHPermissionCategoryBluetooth";
    }
}
