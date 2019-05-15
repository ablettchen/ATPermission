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
@end

@implementation ATViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.singlePermission = [ATPermission new];
    self.multiPermission = [ATPermission new];
    
    [self.singlePermission addPermission:[[ATNotificationsPermission alloc] initWithNotificationCategories:nil]
                                 message:@"We use this to send you\r\nspam and love notes"];
    
    [self.multiPermission addPermission:[[ATContactsPermission alloc] init]
                                message:@"We use this to steal\r\nyour friends"];
    [self.multiPermission addPermission:[[ATLocationWhileInUsePermission alloc] init]
                                message:@"We use this to track\r\nwhere you live"];
    
    [self.multiPermission addPermission:[[ATMicrophonePermission alloc] init]
                                message:@"We use this to record to evaluating word pronunciation"];
    
    
    UIButton *button = ({
        UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:view];
        view.at_size = CGSizeMake(200, 60);
        view.center = self.view.center;
        [view setTitle:@"Action" forState:UIControlStateNormal];
        [view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [view.titleLabel setFont:[UIFont systemFontOfSize:18]];
        view;
    });
    
    [button addTarget:self action:@selector(demoAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)demoAction:(UIButton *)sender {

    [self.singlePermission show:^(BOOL finished, NSArray<ATPermissionResult *> * _Nonnull results) {
        NSLog(@"Changed: %@ - %@", @(finished), results);
    } cancelled:^(NSArray<ATPermissionResult *> * _Nonnull results) {
        NSLog(@"Cancelled");
    }];
    
    /*
    [self.singlePermission statusForPermission:kATPermissionTypeMicrophone completion:^(ATPermissionStatus status) {
        NSLog(@"%@", ATPermissionStatusDescription(status));
        if (status != kATPermissionStatusAuthorized) {
            [self.singlePermission requestMicrophone];
        }
    }];
     */
}

@end
