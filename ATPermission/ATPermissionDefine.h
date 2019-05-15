//
//  ATPermissionDefine.h
//  ATPermission
//  https://github.com/ablettchen/ATPermission
//
//  Created by ablett on 2019/5/13.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#ifndef ATPermissionDefine_h
#define ATPermissionDefine_h


typedef NS_ENUM(NSUInteger, ATPermissionType) {
    kATPermissionTypeContacts,
    kATPermissionTypeLocationAlways,
    kATPermissionTypeLocationInUse,
    kATPermissionTypeNotifications,
    kATPermissionTypeMicrophone,
    kATPermissionTypeCamera,
    kATPermissionTypePhotos,
    kATPermissionTypeReminders,
    kATPermissionTypeEvents,
    kATPermissionTypeBluetooth,
    kATPermissionTypeMotion
};

typedef NS_ENUM(NSUInteger, ATPermissionStatus) {
    kATPermissionStatusAuthorized,
    kATPermissionStatusUnauthorized,
    kATPermissionStatusUnknown,
    kATPermissionStatusDisabled
};

typedef struct {
    float contentWidth;
    float dialogHeightSinglePermission;
    float dialogHeightTwoPermissions;
    float dialogHeightThreePermissions;
}ATConstantsUI;

typedef struct {
    NSString *requestedInUseToAlwaysUpgrade;
    NSString *requestedBluetooth;
    NSString *requestedMotion;
    NSString *requestedNotifications;
}ATConstantsNSUserDefaultsKeys;

typedef struct {
    NSString *locationWhenInUse;
    NSString *locationAlways;
}ATConstantsInfoPlistKeys;

typedef struct {
    ATConstantsUI UI;
    ATConstantsNSUserDefaultsKeys NSUserDefaultsKeys;
    ATConstantsInfoPlistKeys InfoPlistKeys;
}ATConstants;

static const ATConstants at_constants = { \
    {280.0, 260.0, 360.0}, \
    {@"PS_requestedInUseToAlwaysUpgrade", @"PS_requestedBluetooth", @"PS_requestedMotion", @"PS_requestedNotifications"}, \
    {@"NSLocationWhenInUseUsageDescription", @"NSLocationAlwaysUsageDescription"} \
};

#endif /* ATPermissionDefine_h */
