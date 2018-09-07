//
//  ViewController.m
//  NSURLSession
//
//  Created by JiWuChao on 2018/9/7.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()


@property (nonatomic,strong) NSURLSessionTask *task;
// 继承自NSURLSessionTask
@property(nonatomic,strong) NSURLSessionDataTask *dataTask;
// 继承自NSURLSessionTask
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
// 继承自NSURLSessionDataTask
@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 6;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    NSURL *url = [NSURL URLWithString:@"http://rankapi.longzhu.com/ranklist/GetWeekRoomIdItemId?bundleId=com.longzhu.tga&roomId=2100728"];
    self.dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        NSLog(@"res = %@",response);
        NSLog(@"11----%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        //打印解析后的json数据
       NSLog(@"22---%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);

    }];
    [self.dataTask resume];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
