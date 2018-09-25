//
//  ViewController.m
//  NSOperationThreadSave
//
//  Created by JiWuChao on 2018/9/25.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic,assign)NSInteger count;

@property (nonatomic, strong) NSLock *lock;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self aboutThreadSave];
}


- (void)aboutThreadSave {
    NSLog(@"currentThread -- %@",[NSThread currentThread]);
    self.count = 50;
    NSOperationQueue *queue1 = [[NSOperationQueue alloc] init];
    queue1.maxConcurrentOperationCount = 1;
    
    NSOperationQueue *queue2 = [[NSOperationQueue alloc] init];
    queue2.maxConcurrentOperationCount = 1;
    
    __weak typeof(self) weakSelf = self;
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf buyTicket];
    }];
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf buyTicket];
    }];
    
    [queue1 addOperation:op1];
    [queue2 addOperation:op2];
    self.lock = [[NSLock alloc] init];
}

- (void)buyTicket {
    [self.lock lock];
    while (self.count != 0) {
        if (self.count > 0) {
            self.count --;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数:%ld 窗口:%@", (long)self.count, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.5];
        }
        [self.lock unlock];
        
        if (self.count <= 0) {
            NSLog(@"所有火车票均已售完");
            break;
        }
    }
    
}



@end
