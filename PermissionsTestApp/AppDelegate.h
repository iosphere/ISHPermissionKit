//
//  AppDelegate.h
//  PermissionsTestApp
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder<UIApplicationDelegate>

@property (nonatomic, nullable) UIWindow *window;

+ (nonnull NSArray<NSNumber *> *)requiredPermissions;
@end
