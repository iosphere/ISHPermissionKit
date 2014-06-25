//
//  ISHPermissionRequestViewController_private.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 26.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestViewControllerDelegate.h"

@interface ISHPermissionRequestViewController (Private)
- (void)setPermissionDelegate:(id <ISHPermissionRequestViewControllerDelegate>)permissionDelegate;
@end
