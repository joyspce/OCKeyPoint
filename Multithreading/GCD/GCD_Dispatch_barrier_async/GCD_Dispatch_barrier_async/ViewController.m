//
//  ViewController.m
//  GCD_Dispatch_barrier_async
//
//  Created by JiWuChao on 2018/9/27.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self barrierAsync];
//    [self barrierSync];
//    [NSThread detachNewThreadSelector:@selector(barrierSync) toTarget:self withObject:nil];
}

/*
 1.dispatch_barrier_async的作用是等待队列的前面的任务执行完毕后，才执行dispatch_barrier_async的block里面的任务,不会阻塞当前线程；

 */

- (void)barrierAsync {
    
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.barrierAsync", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
      
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:1];
                NSLog(@"2 - %@",[NSThread currentThread]);
            }
        });
//        for (NSInteger i = 0; i < 2; i++) {
//            [NSThread sleepForTimeInterval:1];
//            NSLog(@"2 - %@",[NSThread currentThread]);
//        }
        
    });
    
    dispatch_barrier_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"i %ld dispatch_barrier_async 任务",i);
        }
        [NSThread sleepForTimeInterval:5];
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
    NSLog(@"当前线程阻塞住了吗？没有");
}


/*
 dispatch_barrier_sync的作用是等待队列的前面的任务执行完毕后，才执行dispatch_barrier_async的block里面的任务,阻塞当前线程
 
 */

- (void)barrierSync {
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.barrierAsync", DISPATCH_QUEUE_CONCURRENT);
    
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
  
    dispatch_barrier_sync(queue, ^{
        
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"i %ld dispatch_barrier_sync 任务",i);
        }
        [NSThread sleepForTimeInterval:5];
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
    NSLog(@"当前线程阻塞住了吗？阻塞住了");
}
@end
