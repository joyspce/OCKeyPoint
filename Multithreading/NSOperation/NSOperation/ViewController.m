//
//  ViewController.m
//  NSOperation
//
//  Created by JiWuChao on 2018/9/19.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self invocationOperation];
    [NSThread detachNewThreadSelector:@selector(invocationOperation) toTarget:self withObject:nil];
}

- (void)invocationOperation {
    NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(invocationAction) object:nil];
    [op start];
}

- (void)invocationAction {
    for (int i = 0; i < 2; i++) {
        [NSThread sleepForTimeInterval:2]; // 模拟耗时操作
        NSLog(@"1---%@", [NSThread currentThread]); // 打印当前线程
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
