//
//  ViewController.m
//  Gcd_Dispatch_set_target_queue
//
//  Created by JiWuChao on 2018/9/26.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
//    [self setPriority];
    [self setTarget];
}

#pragma mark - 设置优先级
/*
 dispatch_queue_create函数生成的DisPatch Queue不管是Serial DisPatch Queue还是Concurrent Dispatch Queue,执行的优先级都与默认优先级的Global Dispatch queue相同,如果需要变更生成的Dispatch Queue的执行优先级则需要使用dispatch_set_target_queue函数
 
 */
- (void)setPriority {
    // 默认优先级
    dispatch_queue_t serialQueue = dispatch_queue_create("com.jiwuchao.www.set", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0);
    // 第一个参数为要设置优先级的queue,第二个参数是参照物，既将第一个queue的优先级和第二个queue的优先级设置一样。
    dispatch_set_target_queue(serialQueue, globalQueue);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"我的优先级是 DISPATCH_QUEUE_PRIORITY_LOW");
    });
    
    dispatch_async(serialQueue, ^{
        NSLog(@"我的优先级是1 DISPATCH_QUEUE_PRIORITY_HIGH");
        
    });
 
}

#pragma mark - 设置目标队列
/*
    设置目标队列,使多个serial queue在目标queue上一次只有一个执行
 */
- (void)setTarget {
    //1.创建目标队列
    dispatch_queue_t targetQueue = dispatch_queue_create("test.target.queue", DISPATCH_QUEUE_SERIAL);
    
    //2.创建3个串行队列
    dispatch_queue_t queue1 = dispatch_queue_create("test.1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("test.2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("test.3", DISPATCH_QUEUE_SERIAL);
    
    //3.将3个串行队列分别添加到目标队列
//    dispatch_set_target_queue(queue1, targetQueue);
//    dispatch_set_target_queue(queue2, targetQueue);
//    dispatch_set_target_queue(queue3, targetQueue);

    
    dispatch_async(queue1, ^{
        NSLog(@"queue1 start");
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@"1-thread - %@ ",[NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
        NSLog(@"queue1 end");
    });
    
    /*
        即使把下面的代码打开 queue1 设置为 DISPATCH_QUEUE_CONCURRENT 设置dispatch_set_target_queue 之后 仍然是串行执行
     按道理来讲 应该是并发执行才对吧？ 不解为什么？？？？
     
     dispatch_set_target_queue 可以让三个 串行执行的队列之间 串行执行。如果没有设置 target 队列 那么三个串行队列之间是并发执行的。设置之后是串行执行。但是如果目标队列 target 是 是并发队列 那么这三个队列依然是并发执行，那么就失去了设置target的意义
     
     
     > 问题： queue1 是并发队列 ，异步执行，target 是串行队列，设置 target 之后为什么 queue1 是串行执行？？
     
     > 解答：dispatch_set_target_queue 设置的不仅仅是优先级和target 队列一样，队列的性质也一样了。如果target 是并行/串行 那么queue1 无论是并行/串行 都和target一样了。
     
     
     */
    
//    dispatch_async(queue1, ^{
//        NSLog(@"queue11 start");
//        for (NSInteger i = 0; i < 2; i++) {
//            NSLog(@"11-thread - %@ ",[NSThread currentThread]);
//            [NSThread sleepForTimeInterval:1];
//        }
//        NSLog(@"queue11 end");
//    });
//    dispatch_async(queue1, ^{
//        NSLog(@"queue12 start");
//        for (NSInteger i = 0; i < 2; i++) {
//            NSLog(@"12-thread - %@ ",[NSThread currentThread]);
//            [NSThread sleepForTimeInterval:1];
//        }
//        NSLog(@"queue12 end");
//    });
//
    dispatch_async(queue2, ^{
        NSLog(@"queue2 start");
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@"2-thread - %@ ",[NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
        NSLog(@"queue2 end");
    });
    dispatch_async(queue3, ^{
        NSLog(@"queue3 start");
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@"3-thread - %@ ",[NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
        NSLog(@"queue3 end");
    });
 
}


@end
