//
//  ATPermissionProtocol.h
//  ATPermission
//
//  Created by ablett on 2019/5/14.
//

#import <Foundation/Foundation.h>
#import "ATPermissionDefine.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ATPermissionProtocol <NSObject>
@property (assign, nonatomic, readonly) enum ATPermissionType type;
@end

NS_ASSUME_NONNULL_END
