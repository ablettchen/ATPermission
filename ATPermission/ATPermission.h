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
#import <EventKit/EventKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreMotion/CoreMotion.h>
#import <Contacts/Contacts.h>
#import "ATPermissionDefine.h"
#import "ATPermissionResult.h"
#import "ATPermissionProtocol.h"
#import "ATPermissions.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ATStatusRequestBlock)(ATPermissionStatus status);
typedef void(^ATAuthTypeBlock)(BOOL finished, NSArray<ATPermissionResult *> *results);
typedef void(^ATCancelTypeBlock)(NSArray<ATPermissionResult *> *results);
typedef void(^ATResultsForConfigBlock)(NSArray<ATPermissionResult *> *results);

@interface ATPermission : UIViewController

- (void)addPermission:(__kindof NSObject<ATPermissionProtocol> *)permission message:(NSString *)message;
- (void)statusForPermission:(enum ATPermissionType)type completion:(ATStatusRequestBlock)completion;
- (void)show:(ATAuthTypeBlock)authChange cancelled:(ATCancelTypeBlock)cancelled;

- (void)requestLocationAlways;
- (void)requestLocationInUse;
- (void)requestContacts;
- (void)requestNotifications;
- (void)requestMicrophone;
- (void)requestCamera;
- (void)requestPhotos;
- (void)requestReminders;
- (void)requestEvents;
- (void)requestBluetooth;
- (void)requestMotion;

@end

NS_ASSUME_NONNULL_END
