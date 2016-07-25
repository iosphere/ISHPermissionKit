//
//  GrantedPermissionsViewController.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 10.06.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ISHPermissionKit/ISHPermissionKit.h>

@interface GrantedPermissionsViewController : UITableViewController
- (void)reloadPermissionsUsingDataSource:(id<ISHPermissionsViewControllerDataSource>)datasource;
@end
