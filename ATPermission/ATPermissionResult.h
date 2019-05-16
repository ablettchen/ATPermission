//
//  ATPermissionResult.h
//  ATPermission
//  https://github.com/ablettchen/ATPermission
//
//  Created by ablett on 2019/5/13.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATPermissionConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATPermissionResult : NSObject
@property (assign, nonatomic) enum ATPermissionType type;
@property (assign, nonatomic) enum ATPermissionStatus status;
- (instancetype)initWithType:(enum ATPermissionType)type status:(enum ATPermissionStatus)status;
+ (instancetype)resultWithType:(enum ATPermissionType)type status:(enum ATPermissionStatus)status;
@end

NS_INLINE ATPermissionResult *ATPermissionResultMake(enum ATPermissionType type, enum ATPermissionStatus status) {
    return [ATPermissionResult resultWithType:type status:status];
}

NS_ASSUME_NONNULL_END
