//
//  ATPermissionResult.m
//  ATPermission
//  https://github.com/ablettchen/ATPermission
//
//  Created by ablett on 2019/5/13.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATPermissionResult.h"

@implementation ATPermissionResult

#pragma mark - lifecycle

#pragma mark - overwrite

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ %@", ATPermissionTypeDescription(self.type), ATPermissionStatusDescription(self.status)];
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
