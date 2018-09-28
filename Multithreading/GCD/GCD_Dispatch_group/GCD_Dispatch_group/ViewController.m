//
//  ViewController.m
//  GCD_Dispatch_group
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
//    [self dispathcGroupNotify];
//    [self dispathcGroupWait];
//    [self dispathcGroupLeave];
//    [self dispathcGroupQuestion];
//    [self dispathcGroupAnswer];
    [self dispathcGroupAnswer2];
    
}

- (void)dispathcGroupNotify {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"group---begin");
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue1 = dispatch_queue_create("com.jiwuchao.www1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("com.jiwuchao.www2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue1, ^{
        
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue2, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"4---%@",[NSThread currentThread]);
        }
        NSLog(@"group---end");
    });
}

- (void)dispathcGroupWait {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"group---begin");
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue1 = dispatch_queue_create("com.jiwuchao.www1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("com.jiwuchao.www2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue1, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue2, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    
    // 阻塞 20 秒
    dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)));
    NSLog(@"group---end");

}

- (void)dispathcGroupLeave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"group---begin");
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue1 = dispatch_queue_create("com.jiwuchao.www1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("com.jiwuchao.www2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue2, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程.
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"4---%@",[NSThread currentThread]);
        }
        NSLog(@"group---end");
    });

}



/*
 执行结果：
 
 currentThread---<NSThread: 0x600002a393c0>{number = 1, name = main}
 group---begin
 任务1---<NSThread: 0x600002ab5980>{number = 5, name = (null)}
 任务2的-子任务1 - <NSThread: 0x600002a59b40>{number = 4, name = (null)}
 任务3---<NSThread: 0x600002a0fc80>{number = 3, name = (null)}
 任务2的-子任务1 - <NSThread: 0x600002a59b40>{number = 4, name = (null)}
 任务1---<NSThread: 0x600002ab5980>{number = 5, name = (null)}
 任务3---<NSThread: 0x600002a0fc80>{number = 3, name = (null)}
 前面的异步操作都执行完毕
 开始执行dispatch_group_notify ---<NSThread: 0x600002a393c0>{number = 1, name = m
 任务2的-子任务2 - <NSThread: 0x600002a59b40>{number = 4, name = (null)}
 开始执行dispatch_group_notify ---<NSThread: 0x600002a393c0>{number = 1, name = m
 group---end
 任务2的-子任务2 - <NSThread: 0x600002a59b40>{number = 4, name = (null)}
 任务2的-子任务3 - <NSThread: 0x600002a59b40>{number = 4, name = (null)}
 
 结论 ：
  在第一层次中 任务1 任务2  任务3 其中任务2 有第二层 是一个并发队列有三个子任务
 输出结果：当子任务2的子任务还没有执行完，就开始执行dispatch_group_notify
 
 为什么？
 因为，对于dispatch_group_notify 来说 任务1 任务2 任务3 执行的完的判断标准是 其所在的线程完成。如果其中有子线程那么，由于是异步子线程的完成与否并不影响上一层的线程执行完成
 
 
 */

- (void)dispathcGroupQuestion {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"group---begin");
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue1 = dispatch_queue_create("com.jiwuchao.www1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("com.jiwuchao.www2", DISPATCH_QUEUE_CONCURRENT);
    //任务1
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务1---%@",[NSThread currentThread]);
        }
    });
    // 任务2
    dispatch_group_async(group, queue1, ^{
        
//        for (int i = 0; i < 2; ++i) {
//            [NSThread sleepForTimeInterval:2];
//            NSLog(@"任务2---%@",[NSThread currentThread]);
//        }
        
        dispatch_queue_t queue4 =  dispatch_queue_create("wuchao.w", DISPATCH_QUEUE_CONCURRENT);
        /*
           如果dispatch_async 换成 dispatch_sync 则不会出现 上面的乱序问题y，因为并发队列 + 同步执行 并不能创建多个线程 所有任务2
         的线程结束就是任务2及其子线程执行完的时机
         */
        dispatch_async(queue4, ^{
            // 子任务1
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2];
                NSLog(@"任务2的-子任务1 - %@",[NSThread currentThread]);
            }
            // 子任务2
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2];
                NSLog(@"任务2的-子任务2 - %@",[NSThread currentThread]);
            }
            // 子任务3
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2];
                NSLog(@"任务2的-子任务3 - %@",[NSThread currentThread]);
            }
        });
        
    });
    //任务3
    dispatch_group_async(group, queue2, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务3---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        NSLog(@"前面的异步操作都执行完毕");
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"开始执行dispatch_group_notify ---%@",[NSThread currentThread]);
        }
        NSLog(@"group---end");
    });
}

// 解决方案1 dispatch_group_leave 和 dispatch_group_enter
- (void)dispathcGroupAnswer {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"group---begin");
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue1 = dispatch_queue_create("com.jiwuchao.www1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("com.jiwuchao.www2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_enter(group);
    //任务1
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务1---%@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    //任务2
    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        
        dispatch_queue_t queue4 =  dispatch_queue_create("wuchao.w", DISPATCH_QUEUE_CONCURRENT);
        /*
         如果dispatch_async 换成 dispatch_sync 则不会出现 上面的乱序问题y，因为并发队列 + 同步执行 并不能创建多个线程 所有任务2
         的线程结束就是任务2及其子线程执行完的时机
         */
        dispatch_async(queue4, ^{
            // 子任务1
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2];
                NSLog(@"任务2的-子任务1 - %@",[NSThread currentThread]);
            }
            // 子任务2
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2];
                NSLog(@"任务2的-子任务2 - %@",[NSThread currentThread]);
            }
            // 子任务3
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2];
                NSLog(@"任务2的-子任务3 - %@",[NSThread currentThread]);
            }
            // 子任务1，2，3 是在同一个线程执行 当子任务1，2，3 执行完之后再leave 上层group 告诉nofify 这个任务2 已经完成了 才能正确完成同步 假如子任务中还有嵌套 那么还需要此种解决方法依次类推
            dispatch_group_leave(group);
        });
        // 这一句放在这里是不行的
//        dispatch_group_leave(group);
    });
    //任务3
    dispatch_group_enter(group);
    dispatch_async(queue2, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务3---%@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        NSLog(@"前面的异步操作都执行完毕");
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"开始执行dispatch_group_notify ---%@",[NSThread currentThread]);
        }
        NSLog(@"group---end");
    });
    NSLog(@"不会阻塞主线程-----");
}

// 解决方案2 dispatch_semaphore_t

- (void)dispathcGroupAnswer2 {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"group---begin");
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue1 = dispatch_queue_create("com.jiwuchao.www1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("com.jiwuchao.www2", DISPATCH_QUEUE_CONCURRENT);
    //任务1
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务1---%@",[NSThread currentThread]);
        }
    });
    // 任务2
    dispatch_group_async(group, queue1, ^{
        dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
        dispatch_queue_t queue4 =  dispatch_queue_create("wuchao.w", DISPATCH_QUEUE_CONCURRENT);
        /*
         如果dispatch_async 换成 dispatch_sync 则不会出现 上面的乱序问题y，因为并发队列 + 同步执行 并不能创建多个线程 所有任务2
         的线程结束就是任务2及其子线程执行完的时机
         */
        
        dispatch_async(queue4, ^{
            // 子任务1
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2];
                NSLog(@"任务2的-子任务1 - %@",[NSThread currentThread]);
            }
            // 子任务2
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2];
                NSLog(@"任务2的-子任务2 - %@",[NSThread currentThread]);
            }
            // 子任务3
            for (NSInteger i = 0; i < 2; i++) {
                [NSThread sleepForTimeInterval:2];
                NSLog(@"任务2的-子任务3 - %@",[NSThread currentThread]);
            }
            
            dispatch_semaphore_signal(semaphore);
            
        });
        dispatch_semaphore_wait(semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)));
    });
    //任务3
    dispatch_group_async(group, queue2, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"任务3---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        NSLog(@"前面的异步操作都执行完毕");
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"开始执行dispatch_group_notify ---%@",[NSThread currentThread]);
        }
        NSLog(@"group---end");
    });
}



@end
