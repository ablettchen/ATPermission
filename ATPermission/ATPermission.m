//
//  ATPermission.m
//  ATPermission
//  https://github.com/ablettchen/ATPermission
//
//  Created by ablett on 2019/5/13.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATPermission.h"

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

@property (copy, nonatomic) ATAuthTypeBlock onAuthChange;
@property (copy, nonatomic) ATCancelTypeBlock onCancel;
@property (copy, nonatomic) ATCancelTypeBlock onDisabledOrDenied;

@property (strong, nonatomic) UIViewController *viewControllerForAlerts;

@property (assign, nonatomic) BOOL askedBluetooth;
@property (assign, nonatomic) BOOL waitingForBluetooth;
@property (assign, nonatomic) BOOL askedMotion;
@property (assign, nonatomic) BOOL waitingForMotion;

@property (strong, nonatomic) NSTimer *notificationTimer;

@end

@implementation ATPermission

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _motionPermissionStatus = kATPermissionStatusUnknown;
    _permissionMessages = [NSMutableArray array];
    _permissionButtons = [NSMutableArray array];
    _permissionLabels = [NSMutableArray array];
    _waitingForBluetooth = NO;
    _waitingForMotion = NO;
    
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

- (BOOL)askedBluetooth {
    return [self.defaults boolForKey:at_constants.NSUserDefaultsKeys.requestedBluetooth];
}

- (void)setAskedBluetooth:(BOOL)askedBluetooth {
    [self.defaults setBool:askedBluetooth forKey:at_constants.NSUserDefaultsKeys.requestedBluetooth];
    [self.defaults synchronize];
}

- (BOOL)askedMotion {
    return [self.defaults boolForKey:at_constants.NSUserDefaultsKeys.requestedMotion];
}

- (void)setAskedMotion:(BOOL)askedMotion {
    [self.defaults setBool:askedMotion forKey:at_constants.NSUserDefaultsKeys.requestedMotion];
    [self.defaults synchronize];
}

#pragma mark - privite

- (void)triggerBluetoothStatusUpdate {
    if (@available(iOS 10.0, *)) {
        if (!self.waitingForBluetooth && self.bluetoothManager.state == CBManagerStateUnknown) {
            [self.bluetoothManager startAdvertising:nil];
            [self.bluetoothManager stopAdvertising];
            self.askedBluetooth = YES;
            self.waitingForBluetooth = YES;
        }
    } else {
        // Fallback on earlier versions
    }
}

- (void)triggerMotionStatusUpdate {
    ATPermissionStatus tmpMotionPermissionStatus = self.motionPermissionStatus;
    [self.defaults setBool:YES forKey:at_constants.NSUserDefaultsKeys.requestedMotion];
    [self.defaults synchronize];
    
    NSDate *today = [NSDate date];
    [self.motionManager queryActivityStartingFromDate:today toDate:today toQueue:[NSOperationQueue mainQueue] withHandler:^(NSArray<CMMotionActivity *> * _Nullable activities, NSError * _Nullable error) {
        if (error && error.code == CMErrorMotionActivityNotAuthorized) {
            self.motionPermissionStatus = kATPermissionStatusUnauthorized;
        }else {
            self.motionPermissionStatus = kATPermissionStatusAuthorized;
        }
        [self.motionManager stopActivityUpdates];
        if (tmpMotionPermissionStatus != self.motionPermissionStatus) {
            self.waitingForMotion = NO;
            [self detectAndCallback];
        }
    }];
    self.askedMotion = YES;
    self.waitingForMotion = YES;
}

- (void)showDeniedAlert:(enum ATPermissionType)permission {
    
}

- (void)showDisabledAlert:(enum ATPermissionType)permission {
    
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
            permissionStatus = [self statusContacts];
        }break;
        case kATPermissionTypeNotifications:{
            permissionStatus = [self statusNotifications];
        }break;
        case kATPermissionTypeMicrophone:{
            permissionStatus = [self statusMicrophone];
        }break;
        case kATPermissionTypeCamera:{
            permissionStatus = [self statusCamera];
        }break;
        case kATPermissionTypePhotos:{
            permissionStatus = [self statusPhotos];
        }break;
        case kATPermissionTypeReminders:{
            permissionStatus = [self statusReminders];
        }break;
        case kATPermissionTypeEvents:{
            permissionStatus = [self statusEvents];
        }break;
        case kATPermissionTypeBluetooth:{
            permissionStatus = [self statusBluetooth];
        }break;
        case kATPermissionTypeMotion:{
            permissionStatus = [self statusMotion];
        }break;
    }
    completion(permissionStatus);
}

- (void)detectAndCallback {
    dispatch_async(dispatch_get_main_queue(), ^{
        ATAuthTypeBlock onAuthChange = self.onAuthChange;
        if (onAuthChange) {
            [self getResultsForConfig:^(NSArray<ATPermissionResult *> *results) {
                [self allAuthorized:^(BOOL areAuthorized) {
                    onAuthChange(areAuthorized, results);
                }];
            }];
        }
    });
}

- (void)allAuthorized:(void(^)(BOOL areAuthorized))completion {
    [self getResultsForConfig:^(NSArray<ATPermissionResult *> *results) {
        BOOL result;
        if (results.firstObject) {
            ATPermissionResult *obj = results.firstObject;
            result = (obj.status != kATPermissionStatusAuthorized);
        }else {
            result = NO;
        }
        completion(result);
    }];
}

#pragma mark - ATPermissionStatus and Request

#pragma mark - LocationAlways

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
            BOOL value = [self.defaults boolForKey:at_constants.NSUserDefaultsKeys.requestedInUseToAlwaysUpgrade];
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

- (void)requestLocationAlways {
    BOOL hasAlwaysKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:at_constants.InfoPlistKeys.locationAlways]?YES:NO;
    NSString *desc = [NSString stringWithFormat:@"%@  not found in Info.plist.", at_constants.InfoPlistKeys.locationAlways];
    NSAssert(hasAlwaysKey, desc);
    ATPermissionStatus status = [self statusLocationAlways];
    switch (status) {
        case kATPermissionStatusUnknown:{
            if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
                [self.defaults setBool:YES forKey:at_constants.NSUserDefaultsKeys.requestedInUseToAlwaysUpgrade];
                [self.defaults synchronize];
            }
            [self.locationManager requestAlwaysAuthorization];
        }break;
        case kATPermissionStatusUnauthorized:{
            [self showDeniedAlert:kATPermissionTypeLocationAlways];
        }break;
        case kATPermissionStatusDisabled:{
            [self showDisabledAlert:kATPermissionTypeLocationInUse];
        }break;
        default:
            break;
    }
}

#pragma mark - LocationInUse

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

- (void)requestLocationInUse {
    BOOL hasWhenInUseKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:at_constants.InfoPlistKeys.locationAlways]?YES:NO;
    NSString *desc = [NSString stringWithFormat:@"%@  not found in Info.plist.", at_constants.InfoPlistKeys.locationWhenInUse];
    NSAssert(hasWhenInUseKey, desc);
    ATPermissionStatus status = [self statusLocationInUse];
    switch (status) {
        case kATPermissionStatusUnknown:{
            [self.locationManager requestWhenInUseAuthorization];
        }break;
        case kATPermissionStatusUnauthorized:{
            [self showDeniedAlert:kATPermissionTypeLocationInUse];
        }break;
        case kATPermissionStatusDisabled:{
            [self showDisabledAlert:kATPermissionTypeLocationInUse];
        }break;
        default:
            break;
    }
}

#pragma mark - Contacts

- (ATPermissionStatus)statusContacts {
    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusAuthorized:
                return kATPermissionStatusAuthorized;
            case CNAuthorizationStatusRestricted:
            case CNAuthorizationStatusDenied:
                return kATPermissionStatusUnauthorized;
            case CNAuthorizationStatusNotDetermined:
                return kATPermissionStatusUnknown;
        }
    }else {
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        switch (status) {
            case kABAuthorizationStatusAuthorized:
                return kATPermissionStatusAuthorized;
            case kABAuthorizationStatusRestricted:
            case kABAuthorizationStatusDenied:
                return kATPermissionStatusUnauthorized;
            case kABAuthorizationStatusNotDetermined:
                return kATPermissionStatusUnknown;
        }
    }
}

- (void)requestContacts {
    ATPermissionStatus status = [self statusContacts];
    switch (status) {
        case kATPermissionStatusUnknown:{
            if (@available(iOS 9.0, *)) {
                [[CNContactStore new] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                    [self detectAndCallback];
                 }];
            }else {
                ABAddressBookRequestAccessWithCompletion(nil, ^(bool granted, CFErrorRef error) {
                    [self detectAndCallback];
                });
            }
        }break;
        case kATPermissionStatusUnauthorized:{
            [self showDisabledAlert:kATPermissionTypeContacts];
        }break;
        default:
            break;
    }
}

#pragma mark - Notifications

- (ATPermissionStatus)statusNotifications {
    UIUserNotificationSettings *setting = UIApplication.sharedApplication.currentUserNotificationSettings;
    UIUserNotificationType settingTypes = setting.types;
    if (setting && settingTypes != UIUserNotificationTypeNone) {
        return kATPermissionStatusAuthorized;
    }else {
        if ([self.defaults boolForKey:at_constants.NSUserDefaultsKeys.requestedNotifications]) {
            return kATPermissionStatusUnauthorized;
        }else {
            return kATPermissionStatusUnknown;
        }
    }
}

- (void)showingNotificationPermission {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedShowingNotificationPermission) name:UIApplicationDidBecomeActiveNotification object:nil];
    if (self.notificationTimer) {[self.notificationTimer invalidate];}
}

- (void)finishedShowingNotificationPermission {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    if (self.notificationTimer) {[self.notificationTimer invalidate];}
    [self.defaults setBool:YES forKey:at_constants.NSUserDefaultsKeys.requestedNotifications];
    [self.defaults synchronize];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(100 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        [self getResultsForConfig:^(NSArray<ATPermissionResult *> * _Nonnull results) {
            ATPermissionResult *obj = results.firstObject;
            if (obj && obj.type == kATPermissionTypeNotifications) {}else {return;}
            if (obj.status == kATPermissionStatusUnknown) {
                [self showDeniedAlert:obj.type];
            }else {
                [self detectAndCallback];
            }
        }];
    });
}

- (void)requestNotifications {
    ATPermissionStatus status = [self statusNotifications];
    switch (status) {
        case kATPermissionStatusUnknown:{
            ATNotificationsPermission *notificationsPermission;
            if ([self.configuredPermissions.firstObject isKindOfClass:[ATNotificationsPermission class]]) {
                notificationsPermission = self.configuredPermissions.firstObject;
            }
            NSSet *notificationsPermissionSet = notificationsPermission.notificationCategories;
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showingNotificationPermission) name:UIApplicationWillResignActiveNotification object:nil];
            self.notificationTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(finishedShowingNotificationPermission) userInfo:nil repeats:YES];
            UIUserNotificationType type = UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type categories:notificationsPermissionSet];
            [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        }break;
        case kATPermissionStatusUnauthorized:{
            [self showDisabledAlert:kATPermissionTypeNotifications];
        }break;
        case kATPermissionStatusDisabled:{
            [self showDisabledAlert:kATPermissionTypeNotifications];
        }break;
        case kATPermissionStatusAuthorized:{
            [self detectAndCallback];
        }break;
        default:
            break;
    }
}



#pragma mark - Microphone

- (ATPermissionStatus)statusMicrophone {
    AVAudioSessionRecordPermission recordPermission = AVAudioSession.sharedInstance.recordPermission;
    switch (recordPermission) {
        case AVAudioSessionRecordPermissionDenied:
            return kATPermissionStatusUnauthorized;
        case AVAudioSessionRecordPermissionGranted:
            return kATPermissionStatusAuthorized;
        default:
            return kATPermissionStatusUnknown;
    }
}

#pragma mark - Camera

- (ATPermissionStatus)statusCamera {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case CBPeripheralManagerAuthorizationStatusAuthorized:
            return kATPermissionStatusAuthorized;
        case CBPeripheralManagerAuthorizationStatusRestricted:
        case CBPeripheralManagerAuthorizationStatusDenied:
            return kATPermissionStatusUnauthorized;
        case CBPeripheralManagerAuthorizationStatusNotDetermined:
            return kATPermissionStatusUnknown;
    }
}

#pragma mark - Photos

- (ATPermissionStatus)statusPhotos {
    PHAuthorizationStatus status = PHPhotoLibrary.authorizationStatus;
    switch (status) {
        case PHAuthorizationStatusAuthorized:
            return kATPermissionStatusAuthorized;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
            return kATPermissionStatusUnauthorized;
        case PHAuthorizationStatusNotDetermined:
            return kATPermissionStatusUnknown;
    }
}

#pragma mark - Reminders

- (ATPermissionStatus)statusReminders {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder];
    switch (status) {
        case EKAuthorizationStatusAuthorized:
            return kATPermissionStatusAuthorized;
        case EKAuthorizationStatusRestricted:
        case EKAuthorizationStatusDenied:
            return kATPermissionStatusUnauthorized;
        case EKAuthorizationStatusNotDetermined:
            return kATPermissionStatusUnknown;
    }
}

#pragma mark - Events

- (ATPermissionStatus)statusEvents {
    EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
    switch (status) {
        case EKAuthorizationStatusAuthorized:
            return kATPermissionStatusAuthorized;
        case EKAuthorizationStatusRestricted:
        case EKAuthorizationStatusDenied:
            return kATPermissionStatusUnauthorized;
        case EKAuthorizationStatusNotDetermined:
            return kATPermissionStatusUnknown;
    }
}

#pragma mark - Bluetooth

- (ATPermissionStatus)statusBluetooth {
    if (self.askedBluetooth) {
        [self triggerBluetoothStatusUpdate];
    }else {
        return kATPermissionStatusUnknown;;
    }
    if (@available(iOS 10.0, *)) {
        CBManagerState state = self.bluetoothManager.state;
        CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
        if (state == CBManagerStateUnsupported || \
            state == CBManagerStatePoweredOff || \
            status == CBPeripheralManagerAuthorizationStatusRestricted) {
            return kATPermissionStatusDisabled;
        }else if (state == CBManagerStateUnauthorized ||\
                  status == CBPeripheralManagerAuthorizationStatusDenied) {
            return kATPermissionStatusUnauthorized;
        }else if (state == CBManagerStatePoweredOn && \
                  status == CBPeripheralManagerAuthorizationStatusAuthorized) {
            return kATPermissionStatusAuthorized;
        }else {
            return kATPermissionStatusUnknown;
        }
    } else {
        // Fallback on earlier versions
        return kATPermissionStatusUnknown;
    }
}

#pragma mark - Motion

- (ATPermissionStatus)statusMotion {
    if (self.askedMotion) {
        [self triggerMotionStatusUpdate];
    }
    return self.motionPermissionStatus;
}

#pragma mark -

#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -



@end
