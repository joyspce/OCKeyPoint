//
//  ViewController.m
//  NSThreadDemo
//
//  Created by JiWuChao on 2018/9/25.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong)NSThread * thread;

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
   self.thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadControlAc) object:nil];
    // 为线程设置名称 有利于调试
    [self.thread setName:@"jiwuchao.test.demo"];
    //启动线程
    [self.thread start];
    
    
    
}

- (void)threadControlAc {
    for (NSInteger i = 0; i <= 10 ; i ++) {
        NSLog(@"i = %ld  current thread %@",i,[NSThread currentThread]);
        [NSThread sleepForTimeInterval:1];
        
        if (i == 3 || i == 4) {
            //取消线程并不会马上停止并退出线程，仅仅只作（线程是否需要退出）状态记录
            if (![self.thread isCancelled]) {
                [self.thread cancel];
            } else {
                NSLog(@"线程已经被取消");
            }
        }
        
        if (i == 5) {
            NSLog(@"线程退出");
            //停止方法会立即终止除主线程以外所有线程（无论是否在执行任务）并退出，需要在掌控所有线程状态的情况下调用此方法，否则可能会导致内存问题
            [NSThread exit];
            NSLog(@"不在执行这一步");
        }
    }
}





@end
