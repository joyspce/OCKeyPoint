//
//  ViewController.m
//  NSOperationPriority
//
//  Created by JiWuChao on 2018/9/21.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


/*
 1 queuePriority 属性决定了进入准备就绪状态下的操作之间的开始执行顺序。并且，优先级不能取代依赖关系。
 2 如果一个队列中既包含高优先级操作，又包含低优先级操作，并且两个操作都已经准备就绪，那么队列先执行高优先级操作。
 3 如果，一个队列中既包含了准备就绪状态的操作，又包含了未准备就绪的操作，未准备就绪的操作优先级比准备就绪的操作优先级高。那么，虽然准备就绪的操作优先级低，也会优先执行。优先级不能取代依赖关系。如果要控制操作间的启动顺序，则必须使用依赖关系。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    [self operationPriority];
}


- (void)operationPriority {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i<2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"0: NSThread name = %@",[NSThread currentThread]);
        }
    }];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i<2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1: NSThread name = %@",[NSThread currentThread]);
        }
    }];
    op1.queuePriority = NSOperationQueuePriorityLow;
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i<2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2: NSThread name = %@",[NSThread currentThread]);
        }
    }];
    op2.queuePriority = NSOperationQueuePriorityNormal;
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i<2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3: NSThread name = %@",[NSThread currentThread]);
        }
    }];
    op3.queuePriority = NSOperationQueuePriorityVeryLow;
    
    
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i<2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"4: NSThread name = %@",[NSThread currentThread]);
        }
    }];
    op4.queuePriority = NSOperationQueuePriorityHigh;
    
    NSBlockOperation *op5 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i<2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"5: NSThread name = %@",[NSThread currentThread]);
        }
    }];
    op5.queuePriority = NSOperationQueuePriorityVeryHigh;
    
    [op1 addDependency:op];
    [op2 addDependency:op];
    [op3 addDependency:op];
    [op4 addDependency:op];
    [op5 addDependency:op];
    [queue addOperation:op];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue addOperation:op5];
}


@end
