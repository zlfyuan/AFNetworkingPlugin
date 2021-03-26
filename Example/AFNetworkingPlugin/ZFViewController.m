//
//  ZFViewController.m
//  AFNetworkingPlugin
//
//  Created by zf on 03/26/2021.
//  Copyright (c) 2021 zf. All rights reserved.
//

#import "ZFViewController.h"
#import <AFNetworking.h>
#import "AFHTTPSessionManager+LogIntercept.h"
@interface ZFViewController ()

@end

@implementation ZFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

   
    [[AFHTTPSessionManager manager] GET:@"https://v1.hitokoto.cn/?c=b"
                             parameters:nil
                                headers:nil
                               progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
