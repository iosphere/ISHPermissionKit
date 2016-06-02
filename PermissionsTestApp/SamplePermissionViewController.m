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
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@end

@implementation SamplePermissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *title = nil;
    NSString *text = nil;
    switch (self.permissionCategory) {
        case ISHPermissionCategoryLocationAlways:
        case ISHPermissionCategoryLocationWhenInUse:
            title = @"Location";
            text = @"We really need to know your location.";
            break;

        case ISHPermissionCategoryPhotoCamera:
            title = @"Camera";
            text = @"Smile and grant us access to your camera.";
            break;

        case ISHPermissionCategoryPhotoLibrary:
            title = @"Photos";
            text = @"We would love to save pictures to your camera roll. Please give us acccess to your photo library.";
            break;

        case ISHPermissionCategoryMicrophone:
            title = @"Microphone";
            text = @"Please give us permission to use your microphone. Otherwise we cannot record your voice memos for you.";
            break;

        default:
            title = ISHStringFromPermissionCategory(self.permissionCategory);
            text = @"Yet another permission we need.";
            break;
    }
    [self.titleLabel setText:title];
    [self.textLabel setText:text];
}

- (NSString *)description {
    return [[super description] stringByAppendingFormat:@" - %@", ISHStringFromPermissionCategory(self.permissionCategory)];
}

@end
