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

- (void)viewDidLoad {
    [super viewDidLoad];
    [self operationPriority];
}


- (void)operationPriority {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
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
    
    
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
    [queue addOperation:op5];
}


@end
