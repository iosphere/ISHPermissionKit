//
//  ISHPermissionRequestAccount.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 01.07.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequest.h"

/**
 *  Permission request for an account (social media).
 * 
 *  @sa ISHPermissionCategorySocial<...>
 */
@interface ISHPermissionRequestAccount : ISHPermissionRequest

/**
 *  A unique identifier for the account type.
 *  
 *  Supported system account type identifiers are listed in 
 *  <Accounts/ACAccountType.h>.
 */
@property (nonatomic, readonly, nullable) NSString *accountTypeIdentifier;

/**
 *  An optional dictionary that will be used when requesting access 
 *  to the account of the given type.
 *
 *  @sa requestAccessToAccountsWithType:options:completion:
 */
@property (nonatomic, nullable) NSDictionary *options;

@end
