# ATPermission

[![CI Status](https://img.shields.io/travis/ablettchen@gmail.com/ATPermission.svg?style=flat)](https://travis-ci.org/ablettchen@gmail.com/ATPermission)
[![Version](https://img.shields.io/cocoapods/v/ATPermission.svg?style=flat)](https://cocoapods.org/pods/ATPermission)
[![License](https://img.shields.io/cocoapods/l/ATPermission.svg?style=flat)](https://cocoapods.org/pods/ATPermission)
[![Platform](https://img.shields.io/cocoapods/p/ATPermission.svg?style=flat)](https://cocoapods.org/pods/ATPermission)

## Introduce

![](https://github.com/ablettchen/ATPermission/blob/master/Example/images/permission.gif)

ATPermission 为 [PermissionScope](https://github.com/nickoneill/PermissionScope) 的 Objective-C 版本，感谢 [nickoneill](https://github.com/nickoneill)  大神无私奉献！

支持权限:
* Notifications
* Location (WhileInUse, Always)
* Contacts
* Events
* Microphone
* Camera
* Photos
* Reminders
* Bluetooth
* Motion

支持英文与简体中文

## Example


``` objectiveC
#import "ATPermission.h"

self.singlePermission   = [ATPermission new];
    self.multiPermission    = [ATPermission new];
    self.noUIPermission     = [ATPermission new];
    
    [self.singlePermission addPermission:[[ATNotificationsPermission alloc] initWithNotificationCategories:nil]
                                 message:@"We use this to send you\r\nspam and love notes"];
    
    [self.multiPermission addPermission:[[ATContactsPermission alloc] init]
                                message:@"We use this to steal\r\nyour friends"];
    [self.multiPermission addPermission:[[ATNotificationsPermission alloc] initWithNotificationCategories:nil]
                                message:@"We use this to send you\r\nspam and love notes"];
    [self.multiPermission addPermission:[[ATLocationWhileInUsePermission alloc] init]
                                message:@"We use this to track\r\nwhere you live"];
    
    [self.noUIPermission addPermission:[[ATNotificationsPermission alloc] initWithNotificationCategories:nil] message:@"notifications"];
    [self.noUIPermission addPermission:[ATMicrophonePermission new] message:@"microphone"];
    
    - (void)singlePermissionAction:(UIButton *)sender {
    [self.singlePermission show:^(BOOL finished, NSArray<ATPermissionResult *> * _Nonnull results) {
        NSLog(@"Changed: %@ - %@", @(finished), results);
    } cancelled:^(NSArray<ATPermissionResult *> * _Nonnull results) {
        NSLog(@"Cancelled");
    }];
}

- (void)multiPermissionAction:(UIButton *)sender {
    [self.multiPermission show:^(BOOL finished, NSArray<ATPermissionResult *> * _Nonnull results) {
        NSLog(@"Changed: %@ - %@", @(finished), results);
    } cancelled:^(NSArray<ATPermissionResult *> * _Nonnull results) {
        NSLog(@"Cancelled");
    }];
}

- (void)noUIPermissionAction:(UIButton *)sender {
    [self.noUIPermission requestNotifications];
}

- (void)statusContactsPermissionAction:(UIButton *)sender {
    ATPermission *p = [ATPermission new];
    //p.viewControllerForAlerts = self;
    ATPermissionStatus status = [p statusContacts];
    if (status != kATPermissionStatusAuthorized) {
        [p requestContacts];
    }
    ATPermissionResult *result = ATPermissionResultMake(kATPermissionTypeContacts, status);
    [sender setTitle:result.description forState:UIControlStateNormal];
}

```

## Requirements

## Installation

ATPermission is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ATPermission'
```

## Author

ablettchen@gmail.com, ablett.chen@gmail.com

## License

ATPermission is available under the MIT license. See the LICENSE file for more info.
