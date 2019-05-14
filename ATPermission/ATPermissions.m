//
//  ATPermissions.m
//  ATPermission
//
//  Created by ablett on 2019/5/14.
//

#import "ATPermissions.h"

@implementation NotificationsPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeNotifications;
}

- (instancetype)initWithNotificationCategories:(NSSet <UIUserNotificationCategory *> *)notificationCategories {
    self = [super init];
    if (!self) return nil;
    self.notificationCategories = notificationCategories;
    return self;
}
@end;

@implementation LocationWhileInUsePermission
- (enum ATPermissionType)type {
    return kATPermissionTypeLocationInUse;
}
@end

@implementation LocationAlwaysPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeLocationAlways;
}
@end

@implementation ContactsPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeContacts;
}
@end

@implementation EventsPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeEvents;
}
@end

@implementation MicrophonePermission
- (enum ATPermissionType)type {
    return kATPermissionTypeMicrophone;
}
@end

@implementation CameraPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeCamera;
}
@end

@implementation PhotosPermission
- (enum ATPermissionType)type {
    return kATPermissionTypePhotos;
}
@end

@implementation RemindersPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeReminders;
}
@end

@implementation BluetoothPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeBluetooth;
}
@end

@implementation MotionPermission
- (enum ATPermissionType)type {
    return kATPermissionTypeMotion;
}
@end
