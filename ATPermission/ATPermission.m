//
//  ATPermission.m
//  ATPermission
//  https://github.com/ablettchen/ATPermission
//
//  Created by ablett on 2019/5/13.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATPermission.h"
#import <ATCategories/ATCategories.h>

@interface ATPermission ()<CLLocationManagerDelegate, CBPeripheralManagerDelegate, UIGestureRecognizerDelegate>

///////////////////////////////////////////////////////////////////

@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UILabel *bodyLabel;
@property (strong, nonatomic) UIColor *closeButtonTextColor;

@property (strong, nonatomic) UIColor *permissionButtonTextColor;
@property (strong, nonatomic) UIColor *permissionButtonBorderColor;
@property (assign, nonatomic) CGFloat permissionButtonBorderWidth;
@property (assign, nonatomic) CGFloat permissionButtonCornerRadius;

@property (strong, nonatomic) UIColor *permissionLabelColor;

@property (strong, nonatomic) UIFont *buttonFont;
@property (strong, nonatomic) UIFont *labelFont;

@property (strong, nonatomic) UIButton *closeButton;
@property (assign, nonatomic) CGSize closeOffset;

@property (strong, nonatomic) UIColor *authorizedButtonColor;
@property (strong, nonatomic) UIColor *unauthorizedButtonColor;

@property (strong, nonatomic) UIView *baseView;
@property (strong, nonatomic) UIView *contentView;

///////////////////////////////////////////////////////////////////

@property (strong, nonatomic) NSMutableDictionary<NSNumber *, NSString *> *permissionMessages;

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

- (instancetype)initWithBackgroundTapCancels:(BOOL)backgroundTapCancels {
    self = [super init];
    if (!self) return nil;
    
    _viewControllerForAlerts = self;
    
    _motionPermissionStatus = kATPermissionStatusUnknown;
    _permissionMessages = [NSMutableDictionary dictionary];
    _permissionButtons = [NSMutableArray array];
    _permissionLabels = [NSMutableArray array];
    _waitingForBluetooth = NO;
    _waitingForMotion = NO;
    
    // Set up main view
    self.view.frame = [UIScreen mainScreen].bounds;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self.view addSubview:self.baseView];
    
    // Base View
    self.baseView.frame = self.view.frame;
    [self.baseView addSubview:self.contentView];
    
    if (backgroundTapCancels) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel)];
        tap.delegate = self;
        [self.baseView addGestureRecognizer:tap];
    }
    
    // Content View
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 10;
    self.contentView.layer.masksToBounds = true;
    self.contentView.layer.borderWidth = 0.5f;
    
    // header label
    self.headerLabel.font = [UIFont systemFontOfSize:22];
    self.headerLabel.textColor = [UIColor blackColor];
    self.headerLabel.textAlignment = NSTextAlignmentCenter;
    self.headerLabel.text = @"Hey, listen!".localized;
    self.headerLabel.accessibilityIdentifier = @"permissionscope.headerlabel";
    
    [self.contentView addSubview:self.headerLabel];
    
    // body label
    self.bodyLabel.font = [UIFont systemFontOfSize:16];
    self.bodyLabel.textColor =[UIColor blackColor];
    self.bodyLabel.textAlignment = NSTextAlignmentCenter;
    self.bodyLabel.text = @"We need a couple things\r\nbefore you get started.".localized;
    self.bodyLabel.numberOfLines = 2;
    self.bodyLabel.accessibilityIdentifier = @"permissionscope.bodylabel";
    
    [self.contentView addSubview:self.bodyLabel];
    
    // close button
    [self.closeButton setTitle:@"Close".localized forState:UIControlStateNormal];
    [self.closeButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.closeButton.accessibilityIdentifier = @"permissionscope.closeButton";
    
    [self.contentView addSubview:self.closeButton];
    
    [self statusMotion];
    
    return self;
}

- (instancetype)init {
    return [self initWithBackgroundTapCancels:YES];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    self.view.at_size = screenSize;
    
    CGFloat x = (screenSize.width - at_constants.UI.contentWidth) / 2.f;
    CGFloat dialogHeight;
    switch (self.configuredPermissions.count) {
        case 2:{
            dialogHeight = at_constants.UI.dialogHeightTwoPermissions;
        }break;
        case 3:{
            dialogHeight = at_constants.UI.dialogHeightThreePermissions;
        }break;
        default:{
            dialogHeight = at_constants.UI.dialogHeightSinglePermission;
        }break;
    }
    CGFloat y = (screenSize.height - dialogHeight) / 2.f;
    self.contentView.frame = CGRectMake(x, y, at_constants.UI.contentWidth, dialogHeight);
    
    self.headerLabel.center = self.contentView.center;
    self.headerLabel.frame = CGRectOffset(self.headerLabel.frame, -self.contentView.frame.origin.x, -self.contentView.frame.origin.y);
    self.headerLabel.frame = CGRectOffset(self.headerLabel.frame, 0, -((dialogHeight/2)-50));
    
    self.bodyLabel.center = self.contentView.center;
    self.bodyLabel.frame = CGRectOffset(self.bodyLabel.frame, -self.contentView.frame.origin.x, -self.contentView.frame.origin.y);
    self.bodyLabel.frame = CGRectOffset(self.bodyLabel.frame, 0, -((dialogHeight/2)-100));
    
    self.closeButton.center = self.contentView.center;
    self.closeButton.frame = CGRectOffset(self.closeButton.frame, -self.contentView.frame.origin.x, -self.contentView.frame.origin.y);
    self.closeButton.frame = CGRectOffset(self.closeButton.frame, 105, -((dialogHeight/2)-20));
    self.closeButton.frame = CGRectOffset(self.closeButton.frame, self.closeOffset.width, self.closeOffset.height);
    
    if (self.closeButton.imageView.image) {
        [self.closeButton setTitle:@"" forState:UIControlStateNormal];
    }
    [self.closeButton setTitleColor:self.closeButtonTextColor forState:UIControlStateNormal];
    
    CGFloat baseOffset = 95.f;
    __block NSInteger index = 0;
    for (UIButton *button in self.permissionButtons) {
        button.center = self.contentView.center;
        button.frame = CGRectOffset(button.frame, -self.contentView.frame.origin.x, -self.contentView.frame.origin.y);
        button.frame = CGRectOffset(button.frame, 0, -((dialogHeight/2)-160) + (index * baseOffset));
        
        ATPermissionType type = self.configuredPermissions[index].type;
        
        [self statusForPermission:type completion:^(ATPermissionStatus currentStatus) {
            NSString *prettyDescription = ATPermissionTypePrettyDescription(type);
            if (currentStatus == kATPermissionStatusAuthorized) {
                [self setButtonAuthorizedStyle:button];
                NSString *title = [NSString stringWithFormat:@"Allowed %@", prettyDescription].localized.uppercaseString;
                [button setTitle:title forState:UIControlStateNormal];
            }else if (currentStatus == kATPermissionStatusUnauthorized) {
                [self setButtonUnauthorizedStyle:button];
                NSString *title = [NSString stringWithFormat:@"Denied %@", prettyDescription].localized.uppercaseString;
                [button setTitle:title forState:UIControlStateNormal];
            }else if (currentStatus == kATPermissionStatusDisabled) {
                NSString *title = [NSString stringWithFormat:@"%@ Disabled", prettyDescription].localized.uppercaseString;
                [button setTitle:title forState:UIControlStateNormal];
            }
            
            UILabel *label = self.permissionLabels[index];
            label.center = self.contentView.center;
            label.frame = CGRectOffset(label.frame, -self.contentView.frame.origin.x, -self.contentView.frame.origin.y);
            label.frame = CGRectOffset(label.frame, 0, -((dialogHeight/2)-205) + (index * baseOffset));
            
            index = index + 1;
        }];
    }
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

- (void)setButtonAuthorizedStyle:(UIButton *)button {
    button.layer.borderWidth = 0;
    button.backgroundColor = self.authorizedButtonColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void)setButtonUnauthorizedStyle:(UIButton *)button {
    button.layer.borderWidth = 0;
    button.backgroundColor = self.unauthorizedButtonColor?:[self.authorizedButtonColor inverseColor];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (UIButton *)permissionStyledButton:(enum ATPermissionType)type {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 220, 40)];
    [button setTitleColor:self.permissionButtonTextColor forState:UIControlStateNormal];
    [button.titleLabel setFont:self.buttonFont];
    
    button.layer.borderWidth = self.permissionButtonBorderWidth;
    button.layer.borderColor = self.permissionButtonBorderColor.CGColor;
    button.layer.cornerRadius = self.permissionButtonCornerRadius;
    
    switch (type) {
        case kATPermissionTypeLocationAlways:
        case kATPermissionTypeLocationInUse:{
            NSString *title = [NSString stringWithFormat:@"Enable %@", ATPermissionTypePrettyDescription(type)];
            [button setTitle:title.localized.uppercaseString forState:UIControlStateNormal];
        }break;
        default:{
            NSString *title = [NSString stringWithFormat:@"Allow %@", ATPermissionTypeDescription(type)];
            [button setTitle:title.localized.uppercaseString forState:UIControlStateNormal];
        }break;
    }
    
    NSString *selString = [NSString stringWithFormat:@"request%@", ATPermissionTypeDescription(type)];
    NSString *accessibilityIdentifier = \
    [NSString stringWithFormat:@"permissionscope.button.%@", ATPermissionTypeDescription(type)].lowercaseString;
    [button addTarget:self action:NSSelectorFromString(selString) forControlEvents:UIControlEventTouchUpInside];
    button.accessibilityIdentifier = accessibilityIdentifier;
    return button;
}

- (UILabel *)permissionStyledLabel:(enum ATPermissionType)type {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 50)];
    label.font = self.labelFont;
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.permissionMessages[@(type)];
    label.textColor = self.permissionLabelColor;
    return label;
}

- (void)cancel {
    [self hide];
    if (self.onCancel) {
        [self getResultsForConfig:^(NSArray<ATPermissionResult *> * _Nonnull results) {
            self.onCancel(results);
        }];
    }
}

- (void)hide {
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.2 animations:^{
            self.baseView.at_top = window.at_centerY + 400;
            self.view.alpha = 0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
        }];
        if (self.notificationTimer) {
            [self.notificationTimer invalidate];
            self.notificationTimer = nil;
        }
    });
}

/** Creates the modal viewcontroller and shows it. */
- (void)showAlert {
    // add the backing views
    UIWindow *window = UIApplication.sharedApplication.keyWindow;
    
    //hide KB if it is shown
    [window endEditing:YES];
    
    [window addSubview:self.view];
    self.view.frame = window.bounds;
    
    for (UIButton *button in self.permissionButtons) {
        [button removeFromSuperview];
    }
    [self.permissionButtons removeAllObjects];
    
    for (UILabel *label in self.permissionLabels) {
        [label removeFromSuperview];
    }
    [self.permissionLabels removeAllObjects];
    
    // create the buttons
    for (__kindof NSObject<ATPermissionProtocol> *permission in self.configuredPermissions) {
        UIButton *button = [self permissionStyledButton:permission.type];
        [self.permissionButtons addObject:button];
        [self.contentView addSubview:button];
        
        UILabel *label = [self permissionStyledLabel:permission.type];
        [self.permissionLabels addObject:label];
        [self.contentView addSubview:label];
    }
    
    [self.view setNeedsLayout];
    
    // slide in the view
    self.baseView.at_top = self.view.at_top - self.baseView.at_height;
    self.view.alpha = 0.f;
    
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.baseView.at_centerY = window.at_centerY + 15;
        self.view.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.baseView.center = window.center;
        }];
    }];
}

- (void)showDeniedAlert:(enum ATPermissionType)permission {
    if (self.onDisabledOrDenied) {
        [self getResultsForConfig:^(NSArray<ATPermissionResult *> * _Nonnull results) {
            self.onDisabledOrDenied(results);
        }];
    }
    
    NSString *title = [NSString stringWithFormat:@"Permission for %@ was denied.", ATPermissionTypePrettyDescription(permission)].localized;
    NSString *message = [NSString stringWithFormat:@"Please enable access to %@ in the Settings app", ATPermissionTypePrettyDescription(permission)].localized;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK".localized style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Show me".localized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appForegroundedAfterSettings) name:UIApplicationDidBecomeActiveNotification object:nil];
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewControllerForAlerts presentViewController:alert animated:YES completion:nil];
    });
}

- (void)appForegroundedAfterSettings {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [self detectAndCallback];
}

- (void)showDisabledAlert:(enum ATPermissionType)permission {
    if (self.onDisabledOrDenied) {
        [self getResultsForConfig:^(NSArray<ATPermissionResult *> * _Nonnull results) {
            self.onDisabledOrDenied(results);
        }];
    }
    
    NSString *title = [NSString stringWithFormat:@"%@  is currently disabled.", ATPermissionTypePrettyDescription(permission)].localized;
    NSString *message = [NSString stringWithFormat:@"Please enable access to %@ in Settings", ATPermissionTypePrettyDescription(permission)].localized;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK".localized style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Show me".localized style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appForegroundedAfterSettings) name:UIApplicationDidBecomeActiveNotification object:nil];
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewControllerForAlerts presentViewController:alert animated:YES completion:nil];
    });
}

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

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == self.baseView) {
        return YES;
    }
    return NO;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    [self detectAndCallback];
}

#pragma mark - CBPeripheralManagerDelegate

- (void)peripheralManagerDidUpdateState:(nonnull CBPeripheralManager *)peripheral {
    self.waitingForBluetooth = NO;
    [self detectAndCallback];
}

#pragma mark - privite

#pragma mark - Public

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
        if (self.onAuthChange) {
            [self getResultsForConfig:^(NSArray<ATPermissionResult *> *results) {
                [self allAuthorized:^(BOOL areAuthorized) {
                    self.onAuthChange(areAuthorized, results);
                }];
            }];
        }
    });
}

- (void)addPermission:(__kindof NSObject<ATPermissionProtocol> *)permission message:(NSString *)message {
    NSAssert(!(message.length == 0), @"Including a message about your permission usage is helpful");
    NSAssert((self.configuredPermissions.count < 3), @"Ask for three or fewer permissions at a time");
    __kindof NSObject<ATPermissionProtocol> *obj = self.configuredPermissions.firstObject;
    NSString *string = [NSString stringWithFormat:@"Permission for %@ already set", ATPermissionTypeDescription(permission.type)];
    NSAssert(((obj && (obj.type == permission.type)) ? NO : YES), string);
    
    [self.configuredPermissions addObject:permission];
    self.permissionMessages[@(permission.type)] = message;
    
    if (permission.type == kATPermissionTypeBluetooth && self.askedBluetooth) {
        [self triggerBluetoothStatusUpdate];
    }else if (permission.type == kATPermissionTypeMotion && self.askedMotion) {
        [self triggerMotionStatusUpdate];
    }
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

- (void)requestMicrophone {
    ATPermissionStatus status = [self statusMicrophone];
    switch (status) {
        case kATPermissionStatusUnknown:{
            [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
                [self detectAndCallback];
            }];
        }break;
        case kATPermissionStatusUnauthorized:{
            [self showDeniedAlert:kATPermissionTypeMicrophone];
        }break;
        case kATPermissionStatusDisabled:{
            [self showDisabledAlert:kATPermissionTypeMicrophone];
        }break;
        case kATPermissionStatusAuthorized:{
        }break;
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

- (void)requestCamera {
    ATPermissionStatus status = [self statusCamera];
    switch (status) {
        case kATPermissionStatusUnknown:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                [self detectAndCallback];
            }];
        }break;
        case kATPermissionStatusUnauthorized:{
            [self showDeniedAlert:kATPermissionTypeCamera];
        }break;
        case kATPermissionStatusDisabled:{
            [self showDisabledAlert:kATPermissionTypeCamera];
        }break;
        case kATPermissionStatusAuthorized:{
        }break;
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

- (void)requestPhotos {
    ATPermissionStatus status = [self statusPhotos];
    switch (status) {
        case kATPermissionStatusUnknown:{
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                [self detectAndCallback];
            }];
        }break;
        case kATPermissionStatusUnauthorized:{
            [self showDeniedAlert:kATPermissionTypePhotos];
        }break;
        case kATPermissionStatusDisabled:{
            [self showDisabledAlert:kATPermissionTypePhotos];
        }break;
        case kATPermissionStatusAuthorized:{
        }break;
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

- (void)requestReminders {
    ATPermissionStatus status = [self statusReminders];
    switch (status) {
        case kATPermissionStatusUnknown:{
            [[EKEventStore new] requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error) {
                [self detectAndCallback];
            }];
        }break;
        case kATPermissionStatusUnauthorized:{
            [self showDeniedAlert:kATPermissionTypeReminders];
        }break;
        case kATPermissionStatusDisabled: {}break;
        case kATPermissionStatusAuthorized: {}break;
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

- (void)requestEvents {
    ATPermissionStatus status = [self statusEvents];
    switch (status) {
        case kATPermissionStatusUnknown:{
            [[EKEventStore new] requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError * _Nullable error) {
                [self detectAndCallback];
            }];
        }break;
        case kATPermissionStatusUnauthorized:{
            [self showDeniedAlert:kATPermissionTypeEvents];
        }break;
        case kATPermissionStatusDisabled: {}break;
        case kATPermissionStatusAuthorized: {}break;
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

- (void)requestBluetooth {
    ATPermissionStatus status = [self statusBluetooth];
    switch (status) {
        case kATPermissionStatusUnknown:{
            [self triggerBluetoothStatusUpdate];
        }break;
        case kATPermissionStatusUnauthorized:{
            [self showDeniedAlert:kATPermissionTypeBluetooth];
        }break;
        case kATPermissionStatusDisabled:{
            [self showDisabledAlert:kATPermissionTypeBluetooth];
        }break;
        case kATPermissionStatusAuthorized:{}break;
    }
}

#pragma mark - Motion

- (ATPermissionStatus)statusMotion {
    if (self.askedMotion) {
        [self triggerMotionStatusUpdate];
    }
    return self.motionPermissionStatus;
}

- (void)requestMotion {
    ATPermissionStatus status = [self statusMotion];
    switch (status) {
        case kATPermissionStatusUnknown:{
            [self triggerMotionStatusUpdate];
        }break;
        case kATPermissionStatusUnauthorized:{
            [self showDeniedAlert:kATPermissionTypeMotion];
        }break;
        case kATPermissionStatusDisabled: {}break;
        case kATPermissionStatusAuthorized: {}break;
    }
}

@end
