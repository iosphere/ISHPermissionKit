//
//  ISHPermissionRequestViewController.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ISHPermissionKit/ISHPermissionCategory.h>

@interface ISHPermissionRequestViewController : UIViewController
@property ISHPermissionCategory permissionCategory;

- (IBAction)changePermissionStateToDontAskFromSender:(id)sender NS_REQUIRES_SUPER;
- (IBAction)changePermissionStateToAskAgainFromSender:(id)sender NS_REQUIRES_SUPER;
- (IBAction)requestPermissionFromSender:(id)sender NS_REQUIRES_SUPER;
@end
