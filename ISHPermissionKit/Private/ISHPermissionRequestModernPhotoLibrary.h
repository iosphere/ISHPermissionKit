//
//  ISHPermissionRequestModernPhotoLibrary.h
//  ISHPermissionKit
//
//  Created by Hagi on 24/08/16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import <ISHPermissionKit/ISHPermissionKit.h>

/**
 *  Permission request to acces the user's photo library using
 *  PHPhotoLibrary APIs.
 *
 *  The app must also provide a localized NSPhotoLibraryUsageDescription
 *  in the Info PLIST.
 *
 *  @sa ISHPermissionCategoryModernPhotoLibrary
 */
@interface ISHPermissionRequestModernPhotoLibrary : ISHPermissionRequest

@end
