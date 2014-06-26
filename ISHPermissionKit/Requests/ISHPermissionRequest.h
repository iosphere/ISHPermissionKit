//
//  ISHPermissionRequest.h
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 25.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ISHPermissionKit/ISHPermissionCategory.h>

typedef NS_ENUM(NSUInteger, ISHPermissionState) {
    ISHPermissionStateUnknown = 0,
    ISHPermissionStateNeverAsked = 100,
    ISHPermissionStateAskAgain = 101,
    ISHPermissionStateDontAsk = 110,
    ISHPermissionStateDenied = 403,
    ISHPermissionStateGranted = 200,
};

@class ISHPermissionRequest;

typedef void (^ISHPermissionRequestCompletionBlock)(ISHPermissionRequest *request, ISHPermissionState state, NSError *error);


@interface ISHPermissionRequest : NSObject
@property ISHPermissionCategory permissionCategory;

- (ISHPermissionState)permissionState;
- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion;
@end

static inline NSString *ISHStringFromPermissionState(ISHPermissionState state) {
    switch (state) {
        case ISHPermissionStateUnknown:
            return @"ISHPermissionStateUnknown";
        case ISHPermissionStateNeverAsked:
            return @"ISHPermissionStateNeverAsked";
        case ISHPermissionStateAskAgain:
            return @"ISHPermissionStateAskAgain";
        case ISHPermissionStateDontAsk:
            return @"ISHPermissionStateDontAsk";
        case ISHPermissionStateDenied:
            return @"ISHPermissionStateDenied";
        case ISHPermissionStateGranted:
            return @"ISHPermissionStateGranted";

    }
}

static inline BOOL ISHPermissionStateAllowsUserPrompt(ISHPermissionState state) {
    return (state != ISHPermissionStateDenied) && (state != ISHPermissionStateGranted) && (state != ISHPermissionStateDontAsk);
}

@interface ISHPermissionRequest (Subclasses)
// these interfaces are available to subclasses, there should be no need to override these.
- (ISHPermissionState)internalPermissionState;
- (void)setInternalPermissionState:(ISHPermissionState)state;
@end
