//
//  ISHPermissionRequestHealth.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 01.07.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequest.h"
@class HKObjectType;
@class HKSampleType;

/**
 *  Permission request for the Health database.
 *
 *  @sa ISHPermissionCategoryHealth
 */
@interface ISHPermissionRequestHealth : ISHPermissionRequest
/**
 *  A set of HKObjectType instances you wish to read from HealthKit.
 */
@property (nonatomic, nullable) NSSet<HKObjectType *> *objectTypesRead;
/**
 *  A set of HKObjectType instances you wish to write to HealthKit.
 */
@property (nonatomic, nullable) NSSet<HKSampleType *> *objectTypesWrite;

@end
