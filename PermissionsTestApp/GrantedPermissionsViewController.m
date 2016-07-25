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
NSInteger const RequestabalePermissionsSection = 1;

@interface GrantedPermissionsViewController ()
@property NSArray *permissionsNotRequestable;
@property NSArray *permissionsRequestable;
@end

@implementation GrantedPermissionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.400 green:0.800 blue:1.000 alpha:1.000]];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:GrantedPermissionsViewControllerCell];
    [self reloadPermissionsUsingDataSource:[AppDelegate appDelegate]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.contentInset = UIEdgeInsetsMake(self.topLayoutGuide.length, 0, self.bottomLayoutGuide.length, 0);
}

- (void)reloadPermissionsUsingDataSource:(id<ISHPermissionsViewControllerDataSource>)datasource {
    NSArray *allPermissions = [AppDelegate requiredPermissions];
    ISHPermissionsViewController *viewControllerForStateQueries = [ISHPermissionsViewController permissionsViewControllerWithCategories:allPermissions
                                                                                                                             dataSource:datasource];

    NSArray *requestablePermissions = [viewControllerForStateQueries permissionCategories] ?: @[];

    self.permissionsRequestable = [requestablePermissions sortedArrayUsingSelector:@selector(compare:)];
    NSMutableSet *permissionsNotRequestable = [NSMutableSet setWithArray:allPermissions];
    [permissionsNotRequestable minusSet:[NSSet setWithArray:requestablePermissions]];
    self.permissionsNotRequestable = [[permissionsNotRequestable allObjects] sortedArrayUsingSelector:@selector(compare:)];
    [self.tableView reloadData];
}

- (NSArray *)permissionsForSection:(NSInteger)section {
    if (section == RequestabalePermissionsSection) {
        return self.permissionsRequestable;
    }

    return self.permissionsNotRequestable;
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
    if (section == RequestabalePermissionsSection) {
        return @"Requestable";
    }

    return @"Not requestable";
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

    UIColor *color = (indexPath.section == RequestabalePermissionsSection) ? [UIColor darkTextColor] : [UIColor lightGrayColor];

    cell.textLabel.textColor = color;

    return cell;
}

@end
