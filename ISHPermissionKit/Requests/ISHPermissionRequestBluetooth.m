//
//  ISHPermissionRequestBluetooth.m
//  ISHPermissionKit
//
//  Created by Hagi on 26/08/16.
//  Copyright © 2016 iosphere GmbH. All rights reserved.
//

#import "ISHPermissionRequestBluetooth.h"
#import "ISHPermissionRequest+Private.h"

@import CoreBluetooth;

@interface ISHPermissionRequestBluetooth () <CBCentralManagerDelegate, CBPeripheralManagerDelegate>
@property (nonatomic) ISHPermissionRequestCompletionBlock pendingCompletionBlock;
@property (nonatomic) CBPeripheralManager *pendingPeripheralManager;
@property (nonatomic) CBCentralManager *pendingCentralManager;
@end

@implementation ISHPermissionRequestBluetooth

- (void)dealloc {
    [self stopScanningAndAvertising];
}

- (ISHPermissionState)permissionState {
#if TARGET_OS_SIMULATOR
    // Bluetooth is never supported in the simulator,
    // although the state is unknown until the first
    // time you try to use it
    return ISHPermissionStateUnsupported;
#endif

    ISHPermissionState internalState = [self internalPermissionState];
    // as soon as we create a manager to query its state, the "Turn BT on" prompt will
    // be shown, so we must use the internal fallback until we first request the
    // permission
    if (ISHPermissionStateAllowsUserPrompt(internalState) || (internalState == ISHPermissionStateDoNotAskAgain)) {
        return internalState;
    }

    // if creating a manager won't trigger a prompt, we can get its actual state safely
    switch (self.permissionCategory) {
        case ISHPermissionCategoryBluetoothForeground:
            return [self permissionStateForManagerState:[[CBCentralManager alloc] init].state];

        case ISHPermissionCategoryBluetoothBackground:
            return [self permissionStateForManagerState:[[CBPeripheralManager alloc] init].state];

        default:
            break;
    }

    NSAssert(NO, @"Unknown category: %@", @(self.permissionCategory));
    return internalState;
}

- (ISHPermissionState)permissionStateForManagerState:(CBManagerState)state {
    switch (state) {
        case CBManagerStateUnsupported:
            return ISHPermissionStateUnsupported;

        case CBManagerStateUnauthorized:
            return ISHPermissionStateDenied;

        case CBManagerStatePoweredOn:
            return ISHPermissionStateAuthorized;

        case CBManagerStateUnknown:
            return ISHPermissionStateUnknown;

        case CBManagerStateResetting:
        case CBManagerStatePoweredOff:
            return ISHPermissionStateAskAgain;
    }

    NSAssert(NO, @"Unknown state: %@", @(state));
    return [self internalPermissionState];
}

- (void)requestUserPermissionWithCompletionBlock:(ISHPermissionRequestCompletionBlock)completion {
    if (![self mayRequestUserPermissionWithCompletionBlock:completion]) {
        return;
    }

    self.pendingCompletionBlock = completion;

    switch (self.permissionCategory) {
        case ISHPermissionCategoryBluetoothForeground: {
            CBCentralManager *manager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
            self.pendingCentralManager = manager;
            [manager scanForPeripheralsWithServices:@[] options:nil];
            return;
        }

        case ISHPermissionCategoryBluetoothBackground: {
            CBPeripheralManager *manager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
            self.pendingPeripheralManager = manager;
            [manager startAdvertising:nil];
            return;
        }

        default:
            break;
    }

    NSAssert(NO, @"Failed to create manager for category %@", @(self.permissionCategory));
}

#pragma mark - Bluetooth Delegate

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    [self managerDidUpdateState:central];
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    [self managerDidUpdateState:peripheral];
}

- (void)managerDidUpdateState:(CBManager *)manager {
    [self stopScanningAndAvertising];

    if (!self.pendingCompletionBlock || !manager) {
        NSParameterAssert(self.pendingCompletionBlock);
        NSParameterAssert(manager);
        return;
    }

    ISHPermissionState updatedState = [self permissionStateForManagerState:manager.state];
    [self setInternalPermissionState:updatedState];
    self.pendingCompletionBlock(self, updatedState, nil);
}

- (void)stopScanningAndAvertising {
    [self.pendingCentralManager stopScan];
    [self.pendingPeripheralManager stopAdvertising];
}

#pragma mark - Debugging

#if DEBUG
- (NSArray<NSString *> *)staticUsageDescriptionKeys {
    switch (self.permissionCategory) {
        case ISHPermissionCategoryBluetoothForeground:
            // this request only displays Apple's wording
            // and cannot be customized
            return nil;

        case ISHPermissionCategoryBluetoothBackground:
            return @[@"NSBluetoothPeripheralUsageDescription"];

        default:
            break;
    }

    NSAssert(NO, @"Unknown category: %@", @(self.permissionCategory));
    return nil;
}
#endif

@end
