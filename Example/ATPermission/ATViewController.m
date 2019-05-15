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
@end

@implementation ATViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.singlePermission = [ATPermission new];
    [self.singlePermission addPermission:[ATPhotosPermission new] message:@"hello"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    
    button.at_size = CGSizeMake(200, 60);
    button.center = self.view.center;
    [button setTitle:@"Photos" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [button addTarget:self action:@selector(demoAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)demoAction:(UIButton *)sender {
    
    [self.singlePermission statusForPermission:kATPermissionTypeMicrophone completion:^(ATPermissionStatus status) {
        NSLog(@"%@", ATPermissionStatusDescription(status));
        if (status != kATPermissionStatusAuthorized) {
            [self.singlePermission requestMicrophone];
        }
    }];
    
    
    
    
//    [self.singlePermission show:^(BOOL finished, NSArray<ATPermissionResult *> * _Nonnull results) {
//
//    } cancelled:^(NSArray<ATPermissionResult *> * _Nonnull results) {
//
//    }];
}

@end
