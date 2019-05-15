//
//  ATPermissions.h
//  ATPermission
//
//  Created by ablett on 2019/5/14.
//

#import <Foundation/Foundation.h>
#import "ATPermissionDefine.h"
#import "ATPermissionProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^requestPermissionUnknownResult)(void);
typedef void(^requestPermissionShowAlert)(ATPermissionType type);

@interface ATNotificationsPermission : NSObject<ATPermissionProtocol>
@property (assign, nonatomic) NSSet <UIUserNotificationCategory *> *notificationCategories;
- (instancetype)initWithNotificationCategories:(NSSet <UIUserNotificationCategory *> *)notificationCategories;
@end

@interface ATLocationWhileInUsePermission : NSObject<ATPermissionProtocol> @end
@interface ATLocationAlwaysPermission     : NSObject<ATPermissionProtocol> @end
@interface ATContactsPermission           : NSObject<ATPermissionProtocol> @end
@interface ATEventsPermission             : NSObject<ATPermissionProtocol> @end
@interface ATMicrophonePermission         : NSObject<ATPermissionProtocol> @end
@interface ATCameraPermission             : NSObject<ATPermissionProtocol> @end
@interface ATPhotosPermission             : NSObject<ATPermissionProtocol> @end
@interface ATRemindersPermission          : NSObject<ATPermissionProtocol> @end
@interface ATBluetoothPermission          : NSObject<ATPermissionProtocol> @end
@interface ATMotionPermission             : NSObject<ATPermissionProtocol> @end

NS_ASSUME_NONNULL_END
