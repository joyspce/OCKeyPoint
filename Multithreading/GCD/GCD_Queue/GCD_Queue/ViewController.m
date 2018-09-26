//
//  ViewController.m
//  GCD_Queue
//
//  Created by JiWuChao on 2018/8/4.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma mark 自定义队列 并发
    
    /*
        dispatch_queue_create 生成队列 无论是并发队列还是串行队列 其都是默认优先级
     
     */
    // 并发队列
    dispatch_queue_t customQueue = dispatch_queue_create("com.jiwuchao.GCD_Queue", DISPATCH_QUEUE_CONCURRENT);
    // 串行队列
    dispatch_queue_t customSerial = dispatch_queue_create("com.jiwuchao.gcd_queue.serial", DISPATCH_QUEUE_SERIAL);
    
    //指定
    
    dispatch_queue_t globleBackgtoundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    //表示customQueue 使用的优先级和 globleBackgtoundQueue 的优先级一样
    dispatch_set_target_queue(customQueue, globleBackgtoundQueue);;
    
    
    //主队列
    dispatch_queue_t mainDispathQueue = dispatch_get_main_queue();
    
    //全局队列
    //高优先级
    dispatch_queue_t globlehighQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    //默认优先级
    dispatch_queue_t globleDefaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //低优先级
    dispatch_queue_t globleLowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    //后台
    dispatch_queue_t globleBackgtoundQueue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    
#pragma mark dispatch_group_t
    //1 dispatch_group_notify
    
    /*
        无论向什么类型的 dispatch queue 中添加Dispath group 都可以监视这些执行的结束
     */
    
    
    /**
     串行队列

     @param "ser" <#"ser" description#>
     @param NULL <#NULL description#>
     @return <#return value description#>
     
    dispatch_queue_t serialQuele = dispatch_queue_create("ser", NULL);
    dispatch_group_t group = dispatch_group_create();


    dispatch_group_async(group, serialQuele, ^{
        NSLog(@"1");
    });

    dispatch_group_async(group, serialQuele, ^{
        NSLog(@"2");
    });

    dispatch_group_async(group, serialQuele, ^{
        NSLog(@"3");
    });


    dispatch_group_async(group, serialQuele, ^{
        NSLog(@"4");
    });
    
    dispatch_group_notify(group, serialQuele, ^{
        NSLog(@"结束了");
    });
    
    
    /**
     并行队列
     
    dispatch_queue_t concurrentQuele = dispatch_queue_create("concurrentQuele", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group2 = dispatch_group_create();
    
    
    dispatch_group_async(group2, concurrentQuele, ^{
        NSLog(@"11");
    });
    
    dispatch_group_async(group2, concurrentQuele, ^{
        NSLog(@"22");
    });
    
    dispatch_group_async(group2, concurrentQuele, ^{
        NSLog(@"33");
    });
    
    
    dispatch_group_async(group2, concurrentQuele, ^{
        NSLog(@"44");
    });
    
    dispatch_group_notify(group2, concurrentQuele, ^{
        NSLog(@"结束了");
    });
    //
     */
    
#pragma mark  dispatch_group_notify----------------
    
//    dispatch_queue_t concurrentQuele = dispatch_queue_create("concurrentQuele", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_group_t group2 = dispatch_group_create();
//
//
//    dispatch_group_async(group2, concurrentQuele, ^{
//        NSLog(@"111");
//    });
//
//    dispatch_group_async(group2, concurrentQuele, ^{
//        NSLog(@"222");
//    });
//
//    dispatch_group_async(group2, concurrentQuele, ^{
//        NSLog(@"333");
//    });
//
//
//    dispatch_group_async(group2, concurrentQuele, ^{
//        NSLog(@"444");
//    });
//
//    /*
//        DISPATCH_TIME_FOREVER 表示永久等待
//        dispatch_time_t time =  dispatch_time(DISPATCH_TIME_NOW, 1);
//     */
//
//
//   long result = dispatch_group_wait(group2, DISPATCH_TIME_FOREVER);
//    if (result == 0) {
//        NSLog(@"全部执行完毕。。。");
//    } else {
//        NSLog(@"还在处理中。。。");
//    }

#pragma mark dispath_barrier_async
    
//    dispatch_queue_t queue = dispatch_queue_create("dispath_barrier_async_test", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue, ^{
//        NSLog(@"reading--1");
//    });
//    dispatch_async(queue, ^{
//        NSLog(@"reading--2");
//    });
//
//    dispatch_async(queue, ^{
//        NSLog(@"reading--3");
//    });
//    //能保证 writing--1----- 执行完成之后再执行 reading--4 和 reading--5
//    dispatch_barrier_sync(queue, ^{
//        NSLog(@"writing--1-----");
//    });
//    // 不能保证 writing--1----- 执行完成之后再执行 reading--4 和 reading--5
////    dispatch_async(queue, ^{
////        NSLog(@"writing--1-----");
////    });
//
//    dispatch_async(queue, ^{
//        NSLog(@"reading--4");
//    });
//
//    dispatch_async(queue, ^{
//        NSLog(@"reading--5");
//    });
//
#pragma mark : dispatch_sync 死锁
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    dispatch_sync(mainQueue, ^{
//        NSLog(@"hello world");
//    });
    
    
#pragma mark dispath_apply
    
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_apply(10, queue, ^(size_t index) {
//        NSLog(@"index:%zu",index);
//    });
//    NSLog(@"over");
    
//    NSArray *arr = @[@1,@2,@3,@4,@56,@6,@7,@22];
//    dispatch_queue_t queue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//
//    dispatch_async(queue2, ^{
//       /*
//            Globle Dispath Queue
//            等待dispatch_apply 函数中全部处理执行结果
//        */
//        dispatch_apply([arr count], queue2, ^(size_t index) {
//            /*
//                并列处理包含在NSArray对象的全部对象
//             */
//            NSLog(@"%@",[arr objectAtIndex:index]);
//        });
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            /*
//                在Main Dispath Queue 中执行处理
//                用户界面更新等
//             */
//            NSLog(@"用户界面更新");
//        });
//
//    });
    
#pragma mark - dispatch_suspend/dispatch_resume
    
//    dispatch_queue_t queue3 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue3, ^{
//        NSLog(@"1");
//    });
//    dispatch_async(queue3, ^{
//        NSLog(@"2");
//    });
//    dispatch_async(queue3, ^{
//        NSLog(@"3");
//    });
//
//    dispatch_suspend(queue3);
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        NSLog(@"延迟三秒");
//
//    });
//    dispatch_async(queue3, ^{
//        NSLog(@"4");
//    });
//
//    dispatch_resume(queue3);
    
    
//    dispatch_queue_t queue = dispatch_queue_create("me.tutuge.test.gcd", DISPATCH_QUEUE_SERIAL);
//
//    //提交第一个block，延时5秒打印。
//    dispatch_async(queue, ^{
//        [NSThread sleepForTimeInterval:5];
//        NSLog(@"After 5 seconds...");
//    });
//
//    //提交第二个block，也是延时5秒打印
//    dispatch_async(queue, ^{
//        [NSThread sleepForTimeInterval:5];
//        NSLog(@"After 5 seconds again...");
//    });
//
//    //延时一秒
//    NSLog(@"sleep 1 second...");
//    [NSThread sleepForTimeInterval:1];
//
//    //挂起队列
//    NSLog(@"suspend...");
//    dispatch_suspend(queue);
//
//    //延时10秒
//    NSLog(@"sleep 10 second...");
//    [NSThread sleepForTimeInterval:10];
//
//    //恢复队列
//    NSLog(@"resume...");
//    dispatch_resume(queue);
    
#pragma mark - dispatch_semaphore_t 信号量
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        NSLog(@"任务1完成---- %@", [NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        NSLog(@"任务2完成---- %@", [NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(2);
        NSLog(@"任务3完成---- %@", [NSThread currentThread]);
        dispatch_semaphore_signal(semaphore);
    });
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
