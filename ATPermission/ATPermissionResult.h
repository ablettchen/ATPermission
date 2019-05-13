//
//  ATPermissionResult.h
//  ATPermission
//
//  Created by ablett on 2019/5/14.
//

#import <Foundation/Foundation.h>
#import "ATPermissionDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface ATPermissionResult : NSObject
@property (assign, nonatomic) enum ATPermissionType type;
@property (assign, nonatomic) enum ATPermissionStatus status;
- (instancetype)initWithType:(enum ATPermissionType)type status:(enum ATPermissionStatus)status;
@end

NS_ASSUME_NONNULL_END
