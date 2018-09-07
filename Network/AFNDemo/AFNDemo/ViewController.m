//
//  ViewController.m
//  AFNDemo
//
//  Created by JiWuChao on 2018/9/6.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import <AFNetworking/AFNetworking.h>

#import <AFNetworking/AFHTTPSessionManager.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    [manage GET:@"http://rankapi.longzhu.com/ranklist/GetWeekRoomIdItemId?bundleId=com.longzhu.tga&device=2&packageId=1&roomId=2100728&version=5.2.0" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"res = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
