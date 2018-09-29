//
//  ViewController.m
//  GCD_Dispatch_barrier_async
//
//  Created by JiWuChao on 2018/9/27.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "Download.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self barrierAsync];
//    [self barrierSync];
//    [NSThread detachNewThreadSelector:@selector(barrierSync) toTarget:self withObject:nil];
//    [self barrierAsynQuestion];
    [self barrierAsynAnswer];
    
    
}

/*
 1.dispatch_barrier_async的作用是等待队列的前面的任务执行完毕后，才执行dispatch_barrier_async的block里面的任务,不会阻塞当前线程；

 */

- (void)barrierAsync {
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


/**
 在 dispatch_barrier_async 会出现的问题
 
 
    dispatch_barrier_async 作用是等待队列的前面的任务执行完毕后，才执行
    官方:
    Calls to this function always return immediately after the block has been submitted and never wait for the block to be invoked. When the barrier block reaches the front of a private concurrent queue, it is not executed immediately. Instead, the queue waits until its currently executing blocks finish executing. At that point, the barrier block executes by itself. Any blocks submitted after the barrier block are not executed until the barrier block completes.

    当发生任务嵌套时dispatch_barrier_async
 
    任务1 任务 2 任务3 任务4 是并发执行 任务2  是一个嵌套任务 。
 
    问题: 为什么没有等待  dispatch_barrier_async 之前的任务执行完就开始执行 dispatch_barrier_async 的block任务？？
 
 
 
    情况1 在嵌套任务中有一个任务：
        在并发队列中有单个任务时不会开启新的线程，那么和当前线程(任务2)的线程是同一个线程，当前任务2执行完也就是其中子线程的任务执行完毕。
    情况2 在嵌套任务中有多个任务：
        在并发队列中有多个任务就会开启多个线程异步执行，多个任务异步执行并不会阻塞任务2 的线程，那么任务2 线程执行完毕的标准是把其子任务全部提交到执行队列，那么此时dispatch_barrier_async 检测到 任务1 任务2 都已经完成就会执行dispatch_barrier_async 的任务，但是任务2 系统对完成的判断标准是把其子任务提交到执行队列，此线程的任务已经完成，但是此线程其他的线程它不负责
            所以会出现在看似 线程2还没有执行完就开始执行dispatch_barrier_async 的任务，貌似dispatch_barrier_async 没有起作用和一样。
 
 */
- (void)barrierAsynQuestion {
        NSLog(@"1 current thread -%@",[NSThread currentThread]);
        // 创建一个并发队列
        dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.barrierAsync", DISPATCH_QUEUE_CONCURRENT);
    
        //任务1
        dispatch_async(queue, ^{
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:1];
                NSLog(@"任务1 - %@",[NSThread currentThread]);
            }
        });
        //任务2
        dispatch_async(queue, ^{
            NSLog(@"任务2 current thread -%@",[NSThread currentThread]);
            /*
             第一种情况 会开启新线程
             */
//            // 1 和 dispatch_async(queue, ^{} 是不是同一个线程 重新开启一个线程 异步 执行完之后回调
//            [Download downloadData:^(BOOL success) {
//                NSLog(@"正在执行下载完成之后的任务");
//                [NSThread sleepForTimeInterval:3];
//                NSLog(@"下载完成之后的任务完成");
//            }];
            
            /*
                第二种情况 如果是单个任务 不会开启新线程 如果是多个子任务则会开启线程
             */
            
            dispatch_queue_t queue2 = dispatch_queue_create("com.wuchaoji.http", DISPATCH_QUEUE_CONCURRENT);
            
            dispatch_async(queue2, ^{
                NSLog(@"3 current thread -%@",[NSThread currentThread]);
                // 子任务1
                for (NSInteger i = 0; i < 2; i++) {
                    [NSThread sleepForTimeInterval:1];
                    NSLog(@"子任务1 - %@",[NSThread currentThread]);
                }
                // 子任务2
                for (NSInteger i = 0; i < 2; i++) {
                    [NSThread sleepForTimeInterval:1];
                    NSLog(@"子任务2 - %@",[NSThread currentThread]);
                }
                // 子任务3
                for (NSInteger i = 0; i < 2; i++) {
                    [NSThread sleepForTimeInterval:1];
                    NSLog(@"子任务3 - %@",[NSThread currentThread]);
                }
            });
     
        });
    
        dispatch_barrier_async(queue, ^{
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:1];
                NSLog(@"i %ld dispatch_barrier_async 任务",i);
            }
            [NSThread sleepForTimeInterval:5];
        });
        // 任务3
        dispatch_async(queue, ^{
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:1];
                NSLog(@"任务3 - %@",[NSThread currentThread]);
            }
        });
        // 任务4
        dispatch_async(queue, ^{
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:1];
                NSLog(@"任务4 - %@",[NSThread currentThread]);
            }
        });
    
}

- (void)barrierAsynAnswer {
    NSLog(@"1 current thread -%@",[NSThread currentThread]);
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.barrierAsync", DISPATCH_QUEUE_CONCURRENT);
    
    //任务1
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"任务1 - %@",[NSThread currentThread]);
        }
    });
    //任务2
    dispatch_async(queue, ^{
        NSLog(@"任务2 current thread -%@",[NSThread currentThread]);
        /*
         第一种情况 会开启新线程
         */
        //            // 1 和 dispatch_async(queue, ^{} 是不是同一个线程 重新开启一个线程 异步 执行完之后回调
        //            [Download downloadData:^(BOOL success) {
        //                NSLog(@"正在执行下载完成之后的任务");
        //                [NSThread sleepForTimeInterval:3];
        //                NSLog(@"下载完成之后的任务完成");
        //            }];
        
        /*
         第二种情况 如果是单个任务 不会开启新线程 如果是多个子任务则会开启线程
         */
        
        dispatch_queue_t queue2 = dispatch_queue_create("com.wuchaoji.http", DISPATCH_QUEUE_CONCURRENT);
        
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        
        dispatch_async(queue2, ^{
            NSLog(@"3 current thread -%@",[NSThread currentThread]);
            // 子任务1
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:1];
                NSLog(@"子任务1 - %@",[NSThread currentThread]);
            }
            // 子任务2
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:1];
                NSLog(@"子任务2 - %@",[NSThread currentThread]);
            }
            // 子任务3
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:1];
                NSLog(@"子任务3 - %@",[NSThread currentThread]);
            }
            
            dispatch_semaphore_signal(semaphore);
        });
        // 信号量 等待 最多等待15秒
        dispatch_semaphore_wait(semaphore,dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)));
        
    });
    
    dispatch_barrier_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"i %ld dispatch_barrier_async 任务",i);
        }
        [NSThread sleepForTimeInterval:5];
    });
    // 任务3
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"任务3 - %@",[NSThread currentThread]);
        }
    });
    // 任务4
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"任务4 - %@",[NSThread currentThread]);
        }
    });
    
}


@end
