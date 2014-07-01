//
//  ISHPermissionRequestAccount.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 01.07.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequest.h"

@interface ISHPermissionRequestAccount : ISHPermissionRequest

/// A unique identifier for the account type. Well known system account type identifiers are listed in <Accounts/ACAccountType.h>
@property (nonatomic, readonly) NSString *accountTypeIdentifier;

/**
 *  An optional dictionary that will be used when requesting access to the account of the given type.
 */
@property (nonatomic) NSDictionary *options;

@end
