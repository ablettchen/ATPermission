//
//  ATPermissionResult.m
//  ATPermission
//  https://github.com/ablettchen/ATPermission
//
//  Created by ablett on 2019/5/13.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATPermissionResult.h"

NS_INLINE NSString *typeDescription(enum ATPermissionType type) {
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

NS_INLINE NSString *statusDescription(enum ATPermissionStatus status) {
    switch (status) {
        case kATPermissionStatusAuthorized:        return @"Authorized";
        case kATPermissionStatusUnauthorized:      return @"Unauthorized";
        case kATPermissionStatusUnknown:           return @"Unknown";
        case kATPermissionStatusDisabled:          return @"Disabled"; // System-level
        default:                                   return nil;
    }
}

@implementation ATPermissionResult

#pragma mark - lifecycle

#pragma mark - overwrite

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", typeDescription(self.type), statusDescription(self.status)];
}

#pragma mark - public

- (instancetype)initWithType:(enum ATPermissionType)type status:(enum ATPermissionStatus)status {
    self = [super init];
    if (!self) return nil;
    self.type = type;
    self.status = status;
    return self;
}

+ (instancetype)resultWithType:(enum ATPermissionType)type status:(enum ATPermissionStatus)status {
    return [[ATPermissionResult alloc] initWithType:type status:status];
}

@end
