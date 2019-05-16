//
//  ATViewController.m
//  ATPermission
//  https://github.com/ablettchen/ATPermission
//
//  Created by ablett on 2019/5/13.
//  Copyright (c) 2019 ablett. All rights reserved.
//

#import "ATViewController.h"
#import <ATCategories/ATCategories.h>
#import "ATPermission.h"

@interface ATViewController ()
@property (nonatomic, strong) ATPermission *singlePermission;
@property (nonatomic, strong) ATPermission *multiPermission;
@property (nonatomic, strong) ATPermission *noUIPermission;
@end

@implementation ATViewController

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
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
    
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"ATPermission";

    UIButton *singleBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:view];
        view.at_size = CGSizeMake(200, 50);
        view.at_top = self.view.at_top + 100;
        view.at_centerX = self.view.at_centerX;
        [view setTitle:@"Single permission" forState:UIControlStateNormal];
        [view setTitleColor:UIColorHex(0x0067d8FF) forState:UIControlStateNormal];
        [view setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xF5F5F5FF)] forState:UIControlStateHighlighted];
        [view.titleLabel setFont:[UIFont systemFontOfSize:18]];
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = UIColorHex(0x0067d8FF).CGColor;
        view.layer.cornerRadius = 5.f;
        view.layer.masksToBounds = YES;
        view;
    });
    
    UIButton *multipleBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:view];
        view.at_size = singleBtn.at_size;
        view.at_top = singleBtn.at_bottom + 40;
        view.at_centerX = singleBtn.at_centerX;
        [view setTitle:@"Multiple permission" forState:UIControlStateNormal];
        [view setTitleColor:UIColorHex(0x0067d8FF) forState:UIControlStateNormal];
        [view setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xF5F5F5FF)] forState:UIControlStateHighlighted];
        [view.titleLabel setFont:[UIFont systemFontOfSize:18]];
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = UIColorHex(0x0067d8FF).CGColor;
        view.layer.cornerRadius = 5.f;
        view.layer.masksToBounds = YES;
        view;
    });
    
    UIButton *noUIBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:view];
        view.at_size = multipleBtn.at_size;
        view.at_top = multipleBtn.at_bottom + 40;
        view.at_centerX = multipleBtn.at_centerX;
        [view setTitle:@"No UI permission" forState:UIControlStateNormal];
        [view setTitleColor:UIColorHex(0x0067d8FF) forState:UIControlStateNormal];
        [view setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xF5F5F5FF)] forState:UIControlStateHighlighted];
        [view.titleLabel setFont:[UIFont systemFontOfSize:18]];
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = UIColorHex(0x0067d8FF).CGColor;
        view.layer.cornerRadius = 5.f;
        view.layer.masksToBounds = YES;
        view;
    });
    
    UIButton *getStarusBtn = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:view];
        view.at_size = noUIBtn.at_size;
        view.at_top = noUIBtn.at_bottom + 40;
        view.at_centerX = noUIBtn.at_centerX;
        [view setTitle:@"Check Contacts" forState:UIControlStateNormal];
        [view setTitleColor:UIColorHex(0x0067d8FF) forState:UIControlStateNormal];
        [view setBackgroundImage:[UIImage imageWithColor:UIColorHex(0xF5F5F5FF)] forState:UIControlStateHighlighted];
        [view.titleLabel setFont:[UIFont systemFontOfSize:18]];
        view.layer.borderWidth = 1.f;
        view.layer.borderColor = UIColorHex(0x0067d8FF).CGColor;
        view.layer.cornerRadius = 5.f;
        view.layer.masksToBounds = YES;
        view;
    });

    [singleBtn addTarget:self action:@selector(singlePermissionAction:) forControlEvents:UIControlEventTouchUpInside];
    [multipleBtn addTarget:self action:@selector(multiPermissionAction:) forControlEvents:UIControlEventTouchUpInside];
    [noUIBtn addTarget:self action:@selector(noUIPermissionAction:) forControlEvents:UIControlEventTouchUpInside];
    [getStarusBtn addTarget:self action:@selector(statusContactsPermissionAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

@end
