//
//  ViewController.m
//  GCDUse
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
    // 1 同步执行 + 并发队列
//    [self gcduse1];//
    // 2 异步执行 + 并发队列
//    [self gcduse2];
    // 3 同步执行 + 串行队列
//    [self gcduse3];
    // 4 异步执行 + 串行队列
    [self gcduse4];
//    [self gcduse5];
//    [self gcduse6];
    
}

#pragma mark - 同步执行 + 并发队列
/*
 同步执行 + 并发队列
 在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务
 */
- (void)gcduse1 {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncConcurrent---begin");
    
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.gcduse", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1 - %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2 - %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3 - %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"4 - %@",[NSThread currentThread]);
        }
    });
    NSLog(@"syncConcurrent---end");
}
#pragma mark - 异步执行 + 并发队列
/*
  异步执行 + 并发队列
  */
- (void)gcduse2 {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncConcurrent---begin");
    
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.gcduse", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"4 - %@",[NSThread currentThread]);
        }
    });
    NSLog(@"asyncConcurrent---end");

}

#pragma mark - 同步执行 + 串行队列

/*
 同步执行 + 串行队列
 */
- (void)gcduse3 {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncConcurrent---begin");
    
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.gcduse", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1 - %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2 - %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3 - %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"4 - %@",[NSThread currentThread]);
        }
    });
    NSLog(@"syncConcurrent---end");
}

#pragma mark - 异步执行 + 串行队列
/*
 异步执行 + 串行队列
 */
- (void)gcduse4 {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncConcurrent---begin");
    
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.gcduse", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"4 - %@",[NSThread currentThread]);
        }
    });
    NSLog(@"asyncConcurrent---end");

}
- (void)gcduse5 {
    
}
- (void)gcduse6 {
    
}


@end
