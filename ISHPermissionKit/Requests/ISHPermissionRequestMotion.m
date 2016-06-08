//
//  ISHPermissionRequestMotion.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 26.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestMotion.h"
#import "ISHPermissionRequest+Private.h"

@import CoreMotion;

@interface ISHPermissionRequestMotion ()
@property (nonatomic, strong) CMMotionActivityManager *activityManager;
@property (nonatomic, strong) NSOperationQueue *motionActivityQueue;
@end

@implementation ISHPermissionRequestMotion

- (ISHPermissionState)permissionState {
    if (![CMMotionActivityManager isActivityAvailable]) {
        return ISHPermissionStateUnsupported;
    }
    return [self internalPermissionState];
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }

    [self setInternalPermissionState:ISHPermissionStateDoNotAskAgain]; // avoid asking again
    self.activityManager = [[CMMotionActivityManager alloc] init];
    self.motionActivityQueue = [[NSOperationQueue alloc] init];
    [self.activityManager queryActivityStartingFromDate:[NSDate distantPast] toDate:[NSDate date] toQueue:self.motionActivityQueue withHandler:^(NSArray *activities, NSError *error) {
        ISHPermissionState currentState = ISHPermissionStateUnknown;
        
        if (error && (error.domain == CMErrorDomain) && (error.code == CMErrorMotionActivityNotAuthorized)) {
            currentState = ISHPermissionStateDenied;
        } else if (activities || !error) {
            currentState = ISHPermissionStateAuthorized;
        }
        
        [self setInternalPermissionState:currentState];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, currentState, error);
        });
        
        [self setActivityManager:nil];
        [self setMotionActivityQueue:nil];
    }];
}

@end
