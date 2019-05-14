//
//  ATPermission.h
//  ATPermission
//  https://github.com/ablettchen/ATPermission
//
//  Created by ablett on 2019/5/13.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreMotion/CoreMotion.h>
#import <Contacts/Contacts.h>
#import "ATPermissionDefine.h"
#import "ATPermissionResult.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ATPermissionProtocol <NSObject>
@property (assign, nonatomic, readonly) enum ATPermissionType type;
@end

@interface NotificationsPermission : NSObject<ATPermissionProtocol>
@property (assign, nonatomic) NSSet <UIUserNotificationCategory *> *notificationCategories;
- (instancetype)initWithNotificationCategories:(NSSet <UIUserNotificationCategory *> *)notificationCategories;
@end

@interface LocationWhileInUsePermission : NSObject<ATPermissionProtocol>
@end



@interface ATPermission : NSObject

@end

NS_ASSUME_NONNULL_END
