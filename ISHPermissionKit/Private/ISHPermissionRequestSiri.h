//
//  ISHPermissionRequestSiri.h
//  ISHPermissionKit
//
//  Created by Hagi on 24/08/16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import <ISHPermissionKit/ISHPermissionKit.h>
#ifdef NSFoundationVersionNumber_iOS_9_0

/**
 *  Permission request for Siri to access your app's data.
 *
 *  To use Siri, you must also enable the respective Capability
 *  in your app target.
 *
 *  The app must also provide a localized NSSiriUsageDescription
 *  in the Info PLIST.
 *
 *  @sa ISHPermissionCategorySiri
 */
@interface ISHPermissionRequestSiri : ISHPermissionRequest

@end
#endif
