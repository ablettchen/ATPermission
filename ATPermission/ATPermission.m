//
//  ATPermission.m
//  ATPermission
//  https://github.com/ablettchen/ATPermission
//
//  Created by ablett on 2019/5/13.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATPermission.h"


typedef void(^ATStatusRequestBlock)(ATPermissionStatus status);
typedef void(^ATAuthTypeBlock)(BOOL finished, NSArray<ATPermissionResult *> *results);
typedef void(^ATCancelTypeBlock)(NSArray<ATPermissionResult *> *results);
typedef void(^ATResultsForConfigBlock)(NSArray<ATPermissionResult *> *results);


@interface ATPermission ()<CLLocationManagerDelegate, CBPeripheralManagerDelegate>
@property (strong, nonatomic) NSMutableArray <NSString *> *permissionMessages;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CBPeripheralManager *bluetoothManager;
@property (strong, nonatomic) CMMotionActivityManager *motionManager;
@property (strong, nonatomic) NSUserDefaults *defaults;

@property (assign, nonatomic) ATPermissionStatus motionPermissionStatus;
@property (strong, nonatomic) NSMutableArray <__kindof NSObject<ATPermissionProtocol> *> *configuredPermissions;
@property (strong, nonatomic) NSMutableArray <UIButton *> *permissionButtons;
@property (strong, nonatomic) NSMutableArray <UILabel *> *permissionLabels;

@property (copy, nonatomic) ATStatusRequestBlock onAuthChange;
@property (copy, nonatomic) ATCancelTypeBlock onCancel;
@property (copy, nonatomic) ATCancelTypeBlock onDisabledOrDenied;

@property (strong, nonatomic) UIViewController *viewControllerForAlerts;

@end

@implementation ATPermission

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _motionPermissionStatus = kATPermissionStatusUnknown;
    _permissionMessages = [NSMutableArray array];
    _permissionButtons = [NSMutableArray array];
    _permissionLabels = [NSMutableArray array];
    
    
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

- (void)getResultsForConfig:(ATResultsForConfigBlock)completionBlock {
    NSMutableArray <ATPermissionResult *> *results = [NSMutableArray array];
    for (__kindof NSObject<ATPermissionProtocol> *config in self.configuredPermissions) {
        [self statusForPermission:config.type completion:^(ATPermissionStatus status) {
            ATPermissionResult *result = ATPermissionResultMake(config.type, status);
            [results addObject:result];
        }];
    }
}

- (void)statusForPermission:(enum ATPermissionType)type completion:(ATStatusRequestBlock)completion {
    ATPermissionStatus permissionStatus = kATPermissionStatusUnknown;
    switch (type) {
        case kATPermissionTypeLocationAlways:{
            permissionStatus = [self statusLocationAlways];
        }break;
        case kATPermissionTypeLocationInUse:{
            permissionStatus = [self statusLocationInUse];
        }break;
        case kATPermissionTypeContacts:{
            
        }break;
        case kATPermissionTypeNotifications:{
            
        }break;
        case kATPermissionTypeMicrophone:{
            
        }break;
        case kATPermissionTypeCamera:{
            
        }break;
        case kATPermissionTypePhotos:{
            
        }break;
        case kATPermissionTypeReminders:{
            
        }break;
        case kATPermissionTypeEvents:{
            
        }break;
        case kATPermissionTypeBluetooth:{
            
        }break;
        case kATPermissionTypeMotion:{
            
        }break;
    }
    completion(permissionStatus);
}

#pragma mark - Status

- (ATPermissionStatus)statusLocationAlways {
    if (!CLLocationManager.locationServicesEnabled) {return kATPermissionStatusDisabled;}
    CLAuthorizationStatus status = CLLocationManager.authorizationStatus;
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:{
            return kATPermissionStatusAuthorized;
        }break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            return kATPermissionStatusUnauthorized;
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            BOOL value = [self.defaults valueForKey:at_constants.NSUserDefaultsKeys.requestedInUseToAlwaysUpgrade];
            if (value) {
                return kATPermissionStatusUnauthorized;
            }else {
                return kATPermissionStatusUnknown;
            }
        }
        case kCLAuthorizationStatusNotDetermined:
            return kATPermissionStatusUnknown;
    }
}

- (ATPermissionStatus)statusLocationInUse {
    if (!CLLocationManager.locationServicesEnabled) {return kATPermissionStatusDisabled;}
    CLAuthorizationStatus status = CLLocationManager.authorizationStatus;
    switch (status) {
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways:
            return kATPermissionStatusAuthorized;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            return kATPermissionStatusUnauthorized;
        case kCLAuthorizationStatusNotDetermined:
            return kATPermissionStatusUnknown;
    }
}

#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -



@end
