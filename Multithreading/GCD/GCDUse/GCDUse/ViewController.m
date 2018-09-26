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
//    [self gcduse4];
    // 5 在主线程中： 同步执行 + 主队列
//    [self gcduse5];
    // 5.1 在其他线程 ： 同步执行 + 主队列
//    [NSThread detachNewThreadSelector:@selector(gcduse5) toTarget:self withObject:nil];
      // 6 异步执行 + 主队列
//    [self gcduse6];
    // 线程通信
    [self gcduse7];
    
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

#pragma mark -  同步执行 + 主队列
/*
  同步执行 + 主队列
 */

- (void)gcduse5 {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"run---begin");
    
    // 获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
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
    NSLog(@"run---end");

}

#pragma mark - 异步执行 + 主队列
/*
  异步执行 + 主队列
 */
- (void)gcduse6 {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"run---begin");
    
    // 获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
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
    NSLog(@"run---end");

}


/*
 主线程
 */
- (void)gcduse7 {
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.oo", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i ++ ) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"thread -- %@",[NSThread currentThread]);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"main thread -- %@",[NSThread currentThread]);
            NSLog(@"回到了主线程");
            
        });
        
        
    });
    
}


@end
