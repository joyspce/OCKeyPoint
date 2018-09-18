//
//  ViewController.m
//  AFNDemo
//
//  Created by JiWuChao on 2018/9/6.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ViewController.h"

#import <AFNetworking/AFNetworking.h>

#import <AFNetworking/AFHTTPSessionManager.h>

#import "AFNetworkActivityIndicatorManager.h"

@interface ViewController ()


@property (nonatomic,strong) NSURLSessionDownloadTask *download;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    [manage GET:@"http://rankapi.longzhu.com/ranklist/GetWeekRoomIdItemId?bundleId=com.longzhu.tga" parameters:@{@"roomid":@"2100728"} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"res = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@",error);
    }];
    
    NSURLRequest *request = [[NSURLRequest alloc ] initWithURL:[NSURL URLWithString:@"http://he.yinyuetai.com/uploads/videos/common/8AE4015CA6F6B544282B29F4C1DC0C0A.mp4"]];
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

   self.download = [manage downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        NSLog(@"targetPath - >%@",targetPath);
        NSLog(@"response - >%@",response);
        NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        //拼接文件全路径
        NSString *fullpath = [caches stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *filePathUrl = [NSURL fileURLWithPath:fullpath];
        
        return filePathUrl;
 
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        NSLog(@"error = %@",error);
    }];
    [self.download resume];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
