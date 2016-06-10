//
//  GrantedPermissionsViewController.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 10.06.16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "GrantedPermissionsViewController.h"
#import "AppDelegate.h"
#import <ISHPermissionKit/ISHPermissionRequest+All.h>

NSString * const GrantedPermissionsViewControllerCell = @"cell";

@interface GrantedPermissionsViewController ()
@property NSArray *permissionsGranted;
@property NSArray *permissionsNotGranted;
@end

@implementation GrantedPermissionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:GrantedPermissionsViewControllerCell];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadPermissions];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
}

- (void)reloadPermissions {
    NSSet *permissions = [NSSet setWithArray:[AppDelegate requiredPermissions]];
    NSSet *grantedPermissions = [ISHPermissionRequest grantedPermissionsForCategories:permissions];

    self.permissionsGranted = [[grantedPermissions allObjects] sortedArrayUsingSelector:@selector(compare:)];
    NSMutableSet *missingPermissions = [permissions mutableCopy];
    [missingPermissions minusSet:grantedPermissions];
    self.permissionsNotGranted = [[missingPermissions allObjects] sortedArrayUsingSelector:@selector(compare:)];
    [self.tableView reloadData];
}

- (NSArray *)permissionsForSection:(NSInteger)section {
    if (section) {
        return self.permissionsGranted;
    }

    return self.permissionsNotGranted;
}

- (NSNumber *)permissionAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *permissions = [self permissionsForSection:indexPath.section];

    if (permissions.count <= indexPath.row) {
        return nil;
    }

    return [permissions objectAtIndex:indexPath.row];
}

#pragma mark UITableViewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self permissionsForSection:section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section) {
        return @"Granted";
    }

    return @"Not granted";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GrantedPermissionsViewControllerCell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSNumber *permission = [self permissionAtIndexPath:indexPath];

    if (permission) {
        cell.textLabel.text = ISHStringFromPermissionCategory(permission.unsignedIntegerValue);
    } else {
        cell.textLabel.text = nil;
    }

    return cell;
}

@end
