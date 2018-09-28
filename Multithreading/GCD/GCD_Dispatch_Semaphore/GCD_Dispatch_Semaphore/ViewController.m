//
//  ViewController.m
//  GCD_Dispatch_Semaphore
//
//  Created by JiWuChao on 2018/9/27.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong) dispatch_semaphore_t semaphoreLock;

@property (nonatomic, assign) NSInteger ticketSurplusCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self synchronization];
    [self threadSave];
}

// 线程同步

- (void)synchronization {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        // 追加任务1
        [NSThread sleepForTimeInterval:2];
        NSLog(@"1---%@",[NSThread currentThread]);
        
        number = 100;
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphore---end,number = %d",number);
}

- (void)threadSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    self.semaphoreLock = dispatch_semaphore_create(1);
    
    self.ticketSurplusCount = 10;
    
    dispatch_queue_t queue1 = dispatch_queue_create("wuchao.www1", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t queue2 = dispatch_queue_create("wuchao.www2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
}

- (void)saleTicketSafe {
    
    while (1) {
        // 此时信号量减1 如果信号量减一之后小于或等于0 则等待
        dispatch_semaphore_wait(self.semaphoreLock, DISPATCH_TIME_FOREVER);
        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            // 信号量加1
            dispatch_semaphore_signal(self.semaphoreLock);
            break;
        }
        
        // 相当于解锁 信号量加1
        dispatch_semaphore_signal(self.semaphoreLock);
    }
    
}


@end
