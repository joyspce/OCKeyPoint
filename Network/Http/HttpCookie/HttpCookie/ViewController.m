//
//  ViewController.m
//  HttpCookie
//
//  Created by JiWuChao on 2018/10/16.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#define BaseURL @"https://api.github.com/repos/vmg/redcarpet/issues?state=closed"

//https://api.github.com/repos/vmg/redcarpet/issues?state=closed
@interface ViewController ()
@property (nonatomic, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    [self setCookie];
    [self getMethod];
}

- (void)getMethod {
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:BaseURL]];
    //设置 Content-Type
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"*/*" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"GET"];
    [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    [request setTimeoutInterval:10];
    // 设置User-Agent
    [request setValue:@"sssssssssss" forHTTPHeaderField:@"User-Agent"];
    self.dataTask = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"sss");
        
        if (error) {
            NSLog(@"error: %@",error);
        } else {
            NSLog(@"success ");
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            for (NSHTTPCookie *tempCookie in cookies) {
                //打印获得的cookie
                NSLog(@"getCookie: %@", tempCookie);
            }
        }
    }];
    [self.dataTask resume];
    
}

- (void)postMethod {
    
}
-(void)setCookie{
    NSString * cookStr = [NSString stringWithFormat:@"2FE22674A8E0A41954085716613D462541A8ABDA27F704DA239414A2359B6AC3F02A05CE20FA2D18113E446ADA5624637D629A14E090B86E; _ma=OREN.2.1430659488.1534182910; UM_distinctid=165346d6a632f3-0da94dec5e5362-313f5b26-2c600-165346d6a6460a"];
    NSMutableDictionary * cookieProperties = [NSMutableDictionary dictionary];
    [cookieProperties setObject:@"testCookie" forKey:NSHTTPCookieName];
    [cookieProperties setObject:cookStr forKey:NSHTTPCookieValue];
    [cookieProperties setObject:@"api.github.com" forKey:NSHTTPCookieDomain];
    [cookieProperties setObject:BaseURL forKey:NSHTTPCookieOriginURL];
    [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
    [cookieProperties setObject:@"0.0" forKey:NSHTTPCookieVersion];
    [cookieProperties setValue:[NSDate dateWithTimeIntervalSinceNow:606024360] forKey:NSHTTPCookieExpires];
    NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
}

@end
