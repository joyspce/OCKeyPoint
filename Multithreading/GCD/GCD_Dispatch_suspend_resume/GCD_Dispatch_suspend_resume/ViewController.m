//
//  ViewController.m
//  GCD_Dispatch_suspend_resume
//
//  Created by JiWuChao on 2018/9/28.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self suspendResume];
}

- (void)suspendResume {
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_SERIAL);
    //任务1
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"任务1 ");
    });
    //任务2
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"任务2");
    });

    [NSThread sleepForTimeInterval:1];
    //挂起队列
    NSLog(@"队列挂起此时已经开始执行任务1 但没有开始执行任务2");
    dispatch_suspend(queue);
    //延时10秒
    [NSThread sleepForTimeInterval:10];
    NSLog(@"恢复队列");
    //恢复队列
    dispatch_resume(queue);
    
    
}


@end
