//
//  ATPermissionResult.m
//  ATPermission
//
//  Created by ablett on 2019/5/14.
//

#import "ATPermissionResult.h"

NS_INLINE NSString *typeDescription(enum ATPermissionType type) {
    switch (type) {
        case contacts:         return @"Contacts";
        case events:           return @"Events";
        case locationAlways:   return @"LocationAlways";
        case locationInUse:    return @"LocationInUse";
        case notifications:    return @"Notifications";
        case microphone:       return @"Microphone";
        case camera:           return @"Camera";
        case photos:           return @"Photos";
        case reminders:        return @"Reminders";
        case bluetooth:        return @"Bluetooth";
        case motion:           return @"Motion";
        default:               return nil;
    }
}

NS_INLINE NSString *statusDescription(enum ATPermissionStatus status) {
    switch (status) {
        case authorized:        return @"Authorized";
        case unauthorized:      return @"Unauthorized";
        case unknown:           return @"Unknown";
        case disabled:          return @"Disabled"; // System-level
        default:                return nil;
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

@end
