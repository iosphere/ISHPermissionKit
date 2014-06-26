//
//  LocationPermissionViewController.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 26.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "SamplePermissionViewController.h"
#import <ISHPermissionKit/ISHPermissionKit.h>

@interface SamplePermissionViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation SamplePermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleLabel setText:ISHStringFromPermissionCategory(self.permissionCategory)];
}

@end
