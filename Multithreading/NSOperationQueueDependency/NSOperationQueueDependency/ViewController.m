//
//  ViewController.m
//  NSOperationQueueDependency
//
//  Created by JiWuChao on 2018/9/20.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addDependecy];
}

- (void)addDependecy {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    /*
     如果依赖设置成
     [op1 addDependency: op2];
     [op2 addDependency:op3];
     [queue addOperation:op1];
     
     那么
     queue.maxConcurrentOperationCount = 3;
     
     是无效的 还是串行执行
     
     如果设置成
     [op1 addDependency: op2];
     [op1 addDependency:op3];
     
     那么
     queue.maxConcurrentOperationCount = 3;
     执行的结果是
     
 2 ---> <NSThread: 0x600000477a40>{number = 4, name = (null)}
 3 ---> <NSThread: 0x600000277a40>{number = 3, name = (null)}
 3 ---> <NSThread: 0x600000277a40>{number = 3, name = (null)}
 2 ---> <NSThread: 0x600000477a40>{number = 4, name = (null)}
 1 ---> <NSThread: 0x6000004762c0>{number = 5, name = (null)}
 1 ---> <NSThread: 0x6000004762c0>{number = 5, name = (null)}
     可以看出 2 和 3 是并发执行的
     */
    queue.maxConcurrentOperationCount = 3;
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1 ---> %@",[NSThread currentThread]);
        }
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2 ---> %@",[NSThread currentThread]);
        }
    }];
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3 ---> %@",[NSThread currentThread]);
        }
    }];
    
    /*
    注意 ：依赖不能形成死循环 不然op 是不会被执行的
     如下写法形成死循环
     [op1 addDependency: op2];
     [op2 addDependency:op3];
     [op1 addDependency:op1];
     
     */
    
    [op1 addDependency: op2];
    [op1 addDependency:op3];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
