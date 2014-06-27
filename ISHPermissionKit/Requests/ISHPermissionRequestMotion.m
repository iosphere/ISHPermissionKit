//
//  ISHPermissionRequestMotion.m
//  ISHPermissionKit
//
//  Created by Felix Lamouroux on 26.06.14.
//  Copyright (c) 2014 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestMotion.h"
@import CoreMotion;

@interface ISHPermissionRequestMotion ()
@property (nonatomic, strong) CMPedometer *stepCounter;
@property (nonatomic, strong) NSOperationQueue *motionActivityQueue;
@end

@implementation ISHPermissionRequestMotion

- (ISHPermissionState)permissionState {
    return [self internalPermissionState];
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    NSAssert(completion, @"requestUserPermissionWithCompletionBlock requires a completion block");
    ISHPermissionState currentState = self.permissionState;

    if (!ISHPermissionStateAllowsUserPrompt(currentState)) {
        completion(self, currentState, nil);
        return;
    }

    [self setInternalPermissionState:ISHPermissionStateDontAsk]; // avoid asking again
    self.stepCounter = [[CMPedometer alloc] init];
    self.motionActivityQueue = [[NSOperationQueue alloc] init];
    [self.stepCounter queryPedometerDataFromDate:[NSDate distantPast] toDate:[NSDate date] withHandler:^(CMPedometerData *pedometerData, NSError *error) {
        ISHPermissionState currentState = ISHPermissionStateUnknown;

        if (error && (error.domain == CMErrorDomain) && (error.code == CMErrorMotionActivityNotAuthorized)) {
            currentState = ISHPermissionStateDenied;
        } else if (pedometerData || !error) {
            currentState = ISHPermissionStateGranted;
        }
        
        [self setInternalPermissionState:currentState];

        dispatch_async(dispatch_get_main_queue(), ^{
            completion(self, currentState, error);
        });

        [self setStepCounter:nil];
        [self setMotionActivityQueue:nil];
    }];
}

@end
