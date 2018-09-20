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
    
}

- (void)addDependecy {
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
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
    [op1 addDependency: op2];
    [op1 addDependency:op2];
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
