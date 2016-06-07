//
//  ISHPermissionRequest+Private.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 27.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

/**
 *  These methods are available to subclasses. There should be no
 *  need to override these or to call them from outside of a subclass 
 *  implementation.
 */
@interface ISHPermissionRequest (Subclasses)
/**
 *  @return The permission state saved internally, without
 *          considering state information available by the
 *          system frameworks.
 */
- (ISHPermissionState)internalPermissionState;

/**
 *  @param state The new internal permission state, which will
 *               be persisted.
 */
- (void)setInternalPermissionState:(ISHPermissionState)state;
@end
