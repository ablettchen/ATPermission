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

///////////////////////////////////////////////////////////////////

@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UILabel *bodyLabel;
@property (strong, nonatomic) UIColor *closeButtonTextColor;

@property (strong, nonatomic) UIColor *permissionButtonTextColor;
@property (strong, nonatomic) UIColor *permissionButtonBorderColor;
@property (assign, nonatomic) CGFloat permissionButtonBorderWidth;
@property (assign, nonatomic) CGFloat permissionButtonCornerRadius;
@property (strong, nonatomic) UIColor *permissionLabelColor;

@property (strong, nonatomic) UIFont *buttonFont;
@property (strong, nonatomic) UIFont *labelFont;

@property (strong, nonatomic) UIButton *closeButton;
@property (assign, nonatomic) CGSize closeOffset;

@property (strong, nonatomic) UIColor *authorizedButtonColor;
@property (strong, nonatomic) UIColor *unauthorizedButtonColor;

@property (strong, nonatomic) UIView *contentView;

///////////////////////////////////////////////////////////////////

@property (copy, nonatomic) ATAuthTypeBlock onAuthChange;
@property (copy, nonatomic) ATCancelTypeBlock onCancel;
@property (copy, nonatomic) ATCancelTypeBlock onDisabledOrDenied;

@property (strong, nonatomic) UIViewController *viewControllerForAlerts;

///////////////////////////////////////////////////////////////////

- (void)addPermission:(__kindof NSObject<ATPermissionProtocol> *)permission message:(NSString *)message;
//- (NSDictionary <NSNumber *, NSNumber *> *)permissionStatuses:(nullable NSArray <NSNumber *> *)permissionTypes;
- (void)statusForPermission:(enum ATPermissionType)type completion:(ATStatusRequestBlock)completion;
- (void)show:(ATAuthTypeBlock)authChange cancelled:(ATCancelTypeBlock)cancelled;
- (void)hide;

///////////////////////////////////////////////////////////////////

- (ATPermissionStatus)statusLocationAlways;
- (ATPermissionStatus)statusLocationInUse;
- (ATPermissionStatus)statusContacts;
- (ATPermissionStatus)statusNotifications;
- (ATPermissionStatus)statusMicrophone;
- (ATPermissionStatus)statusCamera;
- (ATPermissionStatus)statusPhotos;
- (ATPermissionStatus)statusReminders;
- (ATPermissionStatus)statusEvents;
- (ATPermissionStatus)statusBluetooth;
- (ATPermissionStatus)statusMotion;

///////////////////////////////////////////////////////////////////

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

///////////////////////////////////////////////////////////////////

@end

NS_ASSUME_NONNULL_END
