//
//  ATPermissions.m
//  ATPermission
//
//  Created by ablett on 2019/5/14.
//

#import "ATPermissions.h"

@implementation NotificationsPermission
- (enum ATPermissionType)type {
    return notifications;
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
    return locationInUse;
}
@end

@implementation LocationAlwaysPermission
- (enum ATPermissionType)type {
    return locationAlways;
}
@end

@implementation ContactsPermission
- (enum ATPermissionType)type {
    return contacts;
}
@end

@implementation EventsPermission
- (enum ATPermissionType)type {
    return events;
}
@end

@implementation MicrophonePermission
- (enum ATPermissionType)type {
    return microphone;
}
@end

@implementation CameraPermission
- (enum ATPermissionType)type {
    return camera;
}
@end

@implementation PhotosPermission
- (enum ATPermissionType)type {
    return photos;
}
@end

@implementation RemindersPermission
- (enum ATPermissionType)type {
    return reminders;
}
@end

@implementation BluetoothPermission
- (enum ATPermissionType)type {
    return bluetooth;
}
@end

@implementation MotionPermission
- (enum ATPermissionType)type {
    return motion;
}
@end
