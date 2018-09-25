//
//  ViewController.m
//  NSThreadDemo
//
//  Created by JiWuChao on 2018/9/25.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
//    [self createThread];
//    [self createThread2];
//    [self createThread3];
    [self threadControl];
}

- (void)runTest {
    NSLog(@"%@",[NSThread currentThread]);
}

- (void)createThread {
    // 创建线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(runTest) object:nil];
    // 为线程设置名称 有利于调试
    [thread setName:@"jiwuchao.test.demo"];
    //启动线程
    [thread start];
}

- (void)createThread2 {
    // 创建线程后自动启动线程 不需要再手动调用 start
    [NSThread detachNewThreadSelector:@selector(runTest) toTarget:self withObject:nil];
}


- (void)createThread3 {
    //隐式创建并启动线程
    [self performSelectorInBackground:@selector(runTest) withObject:nil];
}

- (void)threadControl {
    // 创建线程
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadControlAc) object:nil];
    // 为线程设置名称 有利于调试
    [thread setName:@"jiwuchao.test.demo"];
    //启动线程
    [thread start];
    
    
    
}

- (void)threadControlAc {
    for (NSInteger i = 0; i <= 10 ; i ++) {
        NSLog(@"i = %ld  current thread %@",i,[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1];
        if (i == 5) {
            NSLog(@"线程退出");
            [NSThread exit];
            NSLog(@"不在执行这一步");
        }
    }
}





@end
