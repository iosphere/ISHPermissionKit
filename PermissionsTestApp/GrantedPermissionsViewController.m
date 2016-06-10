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
NSInteger const GrantedPermissionsSection = 1;

@interface GrantedPermissionsViewController ()
@property NSArray *permissionsGranted;
@property NSArray *permissionsNotGranted;
@property NSSet *permissionsRequestable;
@end

@implementation GrantedPermissionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:1.000]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:GrantedPermissionsViewControllerCell];

    [self reloadPermissions];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
}

- (void)reloadPermissions {
    NSArray *allPermissions = [AppDelegate requiredPermissions];
    NSArray *grantedPermissions = [ISHPermissionRequest grantedPermissionsForCategories:allPermissions];

    self.permissionsGranted = [grantedPermissions sortedArrayUsingSelector:@selector(compare:)];
    NSMutableSet *missingPermissions = [NSMutableSet setWithArray:allPermissions];
    [missingPermissions minusSet:[NSSet setWithArray:grantedPermissions]];
    self.permissionsNotGranted = [[missingPermissions allObjects] sortedArrayUsingSelector:@selector(compare:)];
    self.permissionsRequestable = [NSSet setWithArray:[ISHPermissionRequest requestablePermissionsForCategories:self.permissionsNotGranted]];
    [self.tableView reloadData];
}

- (NSArray *)permissionsForSection:(NSInteger)section {
    if (section == GrantedPermissionsSection) {
        return self.permissionsGranted;
    }

    return self.permissionsNotGranted;
}

- (NSNumber *)permissionAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *permissions = [self permissionsForSection:indexPath.section];

    if (indexPath.row >= permissions.count) {
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
    if (section == GrantedPermissionsSection) {
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

    UIColor *color = [UIColor greenColor];
    if (indexPath.section != GrantedPermissionsSection) {
        // Use redColor for permissions that cannot be requested
        color = [self.permissionsRequestable containsObject:permission] ? [UIColor darkTextColor] : [UIColor redColor];
    }
    cell.textLabel.textColor = color;

    return cell;
}

@end
