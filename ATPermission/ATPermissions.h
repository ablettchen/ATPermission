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

@interface NotificationsPermission : NSObject<ATPermissionProtocol>
@property (assign, nonatomic) NSSet <UIUserNotificationCategory *> *notificationCategories;
- (instancetype)initWithNotificationCategories:(NSSet <UIUserNotificationCategory *> *)notificationCategories;
@end

@interface LocationWhileInUsePermission : NSObject<ATPermissionProtocol> @end
@interface LocationAlwaysPermission     : NSObject<ATPermissionProtocol> @end
@interface ContactsPermission           : NSObject<ATPermissionProtocol> @end
@interface EventsPermission             : NSObject<ATPermissionProtocol> @end
@interface MicrophonePermission         : NSObject<ATPermissionProtocol> @end
@interface CameraPermission             : NSObject<ATPermissionProtocol> @end
@interface PhotosPermission             : NSObject<ATPermissionProtocol> @end
@interface RemindersPermission          : NSObject<ATPermissionProtocol> @end
@interface BluetoothPermission          : NSObject<ATPermissionProtocol> @end
@interface MotionPermission             : NSObject<ATPermissionProtocol> @end

NS_ASSUME_NONNULL_END
