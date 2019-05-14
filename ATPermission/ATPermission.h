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


@interface ATPermission : NSObject

- (void)requestLocationAlways;
- (void)requestLocationInUse;

@end

NS_ASSUME_NONNULL_END
