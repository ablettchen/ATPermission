//
//  ATPermission.m
//  ATPermission
//  https://github.com/ablettchen/ATPermission
//
//  Created by ablett on 2019/5/13.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATPermission.h"

typedef void(^statusRequestBlock)(ATPermissionStatus status);
typedef void(^authTypeBlock)(BOOL finished, NSArray<ATPermissionResult *> *results);
typedef void(^cancelTypeBlock)(NSArray<ATPermissionResult *> *results);
typedef void(^resultsForConfigBlock)(NSArray<ATPermissionResult *> *results);


@implementation NotificationsPermission

#pragma mark - ATPermissionProtocol

- (enum ATPermissionType)type {
    return notifications;
}

#pragma mark - public

- (instancetype)initWithNotificationCategories:(NSSet <UIUserNotificationCategory *> *)notificationCategories {
    self = [super init];
    if (!self) return nil;
    self.notificationCategories = notificationCategories;
    return self;
}

@end;

@implementation LocationWhileInUsePermission

#pragma mark - ATPermissionProtocol

- (enum ATPermissionType)type {
    return locationInUse;
}

@end

@interface ATPermission ()<CLLocationManagerDelegate, CBPeripheralManagerDelegate>
@property (strong, nonatomic) NSMutableArray <NSString *> *permissionMessages;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CBPeripheralManager *bluetoothManager;
@property (strong, nonatomic) CMMotionActivityManager *motionManager;
@property (strong, nonatomic) NSUserDefaults *defaults;

@property (assign, nonatomic) ATPermissionStatus motionPermissionStatus;
@property (strong, nonatomic) NSMutableArray <NSObject<ATPermissionProtocol> *> *configuredPermissions;

@end

@implementation ATPermission

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    _permissionMessages = [NSMutableArray array];
    _motionPermissionStatus = unknown;
    
    return self;
}

#pragma mark - setter, getter;

- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (CBPeripheralManager *)bluetoothManager {
    if (!_bluetoothManager) {
        _bluetoothManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil options:@{CBPeripheralManagerOptionShowPowerAlertKey : @(NO)}];
    }
    return _bluetoothManager;
}

- (CMMotionActivityManager *)motionManager {
    if (!_motionManager) {
        _motionManager = [CMMotionActivityManager new];
    }
    return _motionManager;
}

- (NSUserDefaults *)defaults {
    return [NSUserDefaults standardUserDefaults];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(nonnull CBPeripheralManager *)peripheral {
    
}

#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -



@end
