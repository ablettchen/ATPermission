//
//  ATPermissionConst.h
//  ATPermission
//
//  Created by ablett on 2019/5/16.
//

#import <UIKit/UIKit.h>

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

NS_INLINE NSString *ATPermissionTypeDescription(enum ATPermissionType type) {
    switch (type) {
            case kATPermissionTypeContacts:         return @"Contacts";
            case kATPermissionTypeEvents:           return @"Events";
            case kATPermissionTypeLocationAlways:   return @"LocationAlways";
            case kATPermissionTypeLocationInUse:    return @"LocationInUse";
            case kATPermissionTypeNotifications:    return @"Notifications";
            case kATPermissionTypeMicrophone:       return @"Microphone";
            case kATPermissionTypeCamera:           return @"Camera";
            case kATPermissionTypePhotos:           return @"Photos";
            case kATPermissionTypeReminders:        return @"Reminders";
            case kATPermissionTypeBluetooth:        return @"Bluetooth";
            case kATPermissionTypeMotion:           return @"Motion";
        default:                                return nil;
    }
}

NS_INLINE NSString *ATPermissionTypePrettyDescription(enum ATPermissionType type) {
    if (type == kATPermissionTypeLocationAlways || \
        type == kATPermissionTypeLocationInUse) {
        return @"Location";
    }else {
        return ATPermissionTypeDescription(type);
    }
}

typedef NS_ENUM(NSUInteger, ATPermissionStatus) {
    kATPermissionStatusAuthorized,
    kATPermissionStatusUnauthorized,
    kATPermissionStatusUnknown,
    kATPermissionStatusDisabled
};

NS_INLINE NSString *ATPermissionStatusDescription(enum ATPermissionStatus status) {
    switch (status) {
            case kATPermissionStatusAuthorized:        return @"Authorized";
            case kATPermissionStatusUnauthorized:      return @"Unauthorized";
            case kATPermissionStatusUnknown:           return @"Unknown";
            case kATPermissionStatusDisabled:          return @"Disabled"; // System-level
            default:                                   return nil;
    }
}

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

NS_INLINE NSString *ATPermissionTypeTextPrettyKey(enum ATPermissionType type) {
    return [NSString stringWithFormat:@"kATPermission%@Text", ATPermissionTypePrettyDescription(type)];
}

UIKIT_EXTERN ATConstants const at_constants;

UIKIT_EXTERN NSString *const kATPermissionOKText;            ///< 好
UIKIT_EXTERN NSString *const kATPermissionShowMeText;        ///< 去设置
UIKIT_EXTERN NSString *const kATPermissionCloseText;        ///< 关闭
UIKIT_EXTERN NSString *const kATPermissionHeaderText;       ///< 标题
UIKIT_EXTERN NSString *const kATPermissionBodyText;         ///< 描述
UIKIT_EXTERN NSString *const kATPermissionAllowedText;      ///< 允许
UIKIT_EXTERN NSString *const kATPermissionEnableText;       ///< 打开
UIKIT_EXTERN NSString *const kATPermissionDeniedText;       ///< 拒绝
UIKIT_EXTERN NSString *const kATPermissionDisabledText;     ///< 不可见
UIKIT_EXTERN NSString *const kATPermissionContactsText;
UIKIT_EXTERN NSString *const kATPermissionEventsText;
UIKIT_EXTERN NSString *const kATPermissionLocationText;
UIKIT_EXTERN NSString *const kATPermissionNotificationsText;
UIKIT_EXTERN NSString *const kATPermissionMicrophoneText;
UIKIT_EXTERN NSString *const kATPermissionCameraText;
UIKIT_EXTERN NSString *const kATPermissionPhotosText;
UIKIT_EXTERN NSString *const kATPermissionRemindersText;
UIKIT_EXTERN NSString *const kATPermissionBluetoothText;
UIKIT_EXTERN NSString *const kATPermissionMotionText;


