//
//  ATPermissionConst.m
//  ATPermission
//
//  Created by ablett on 2019/5/16.
//

#import "ATPermissionConst.h"

NSString *const kATPermissionOKText             = @"kATPermissionOKText";
NSString *const kATPermissionShowMeText         = @"kATPermissionShowMeText";
NSString *const kATPermissionCloseText          = @"kATPermissionCloseText";
NSString *const kATPermissionHeaderText         = @"kATPermissionHeaderText";
NSString *const kATPermissionBodyText           = @"kATPermissionBodyText";
NSString *const kATPermissionAllowedText        = @"kATPermissionAllowedText";
NSString *const kATPermissionEnableText         = @"kATPermissionEnableText";
NSString *const kATPermissionDeniedText         = @"kATPermissionDeniedText";
NSString *const kATPermissionDisabledText       = @"kATPermissionDisabledText";
NSString *const kATPermissionContactsText       = @"kATPermissionContactsText";
NSString *const kATPermissionEventsText         = @"kATPermissionEventsText";
NSString *const kATPermissionLocationText       = @"kATPermissionLocationText";
NSString *const kATPermissionNotificationsText  = @"kATPermissionNotificationsText";
NSString *const kATPermissionMicrophoneText     = @"kATPermissionMicrophoneText";
NSString *const kATPermissionCameraText         = @"kATPermissionCameraText";
NSString *const kATPermissionPhotosText         = @"kATPermissionPhotosText";
NSString *const kATPermissionRemindersText      = @"kATPermissionRemindersText";
NSString *const kATPermissionBluetoothText      = @"kATPermissionBluetoothText";
NSString *const kATPermissionMotionText         = @"kATPermissionMotionText";


ATConstants const at_constants = { \
    {280.0, 260.0, 360.0, 460.0}, \
    {@"PS_requestedInUseToAlwaysUpgrade", @"PS_requestedBluetooth", @"PS_requestedMotion", @"PS_requestedNotifications"}, \
    {@"NSLocationWhenInUseUsageDescription", @"NSLocationAlwaysUsageDescription"} \
};
