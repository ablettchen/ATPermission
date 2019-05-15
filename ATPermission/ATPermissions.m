//
//  ATPermissions.m
//  ATPermission
//
//  Created by ablett on 2019/5/14.
//

#import "ATPermissions.h"

@implementation ATNotificationsPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeNotifications;
}

- (instancetype)initWithNotificationCategories:(nullable NSSet <UIUserNotificationCategory *> *)notificationCategories {
    self = [super init];
    if (!self) return nil;
    self.notificationCategories = notificationCategories;
    return self;
}
@end;

@implementation ATLocationWhileInUsePermission
- (enum ATPermissionType)type {
    return kATPermissionTypeLocationInUse;
}
@end

@implementation ATLocationAlwaysPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeLocationAlways;
}
@end

@implementation ATContactsPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeContacts;
}
@end

@implementation ATEventsPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeEvents;
}
@end

@implementation ATMicrophonePermission
- (enum ATPermissionType)type {
    return kATPermissionTypeMicrophone;
}
@end

@implementation ATCameraPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeCamera;
}
@end

@implementation ATPhotosPermission
- (enum ATPermissionType)type {
    return kATPermissionTypePhotos;
}
@end

@implementation ATRemindersPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeReminders;
}
@end

@implementation ATBluetoothPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeBluetooth;
}
@end

@implementation ATMotionPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeMotion;
}
@end
