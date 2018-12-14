//
//  ViewController.m
//  Notification
//
//  Created by JiWuChao on 2018/12/13.
//  Copyright © 2018 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self test];
    
//    [self test2];
    [self test3];
}

//1 NSNotification使用的是同步操作 下面例子证明
- (void)test {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNofi) name:@"ssss" object:nil];
    
    NSLog(@"发送了通知");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ssss" object:nil];
    
    NSLog(@"沉睡了 5s 之后才走到这里");

}

- (void)receiveNofi {
    [NSThread sleepForTimeInterval:5];
    NSLog(@"沉睡了 5s");
}


// 2 对于同一个通知，如果注册了多个观察者，则这多个观察者的执行顺序和他们的注册顺序是保持一致的。
- (void)test2 {
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(second) name:@"ssss" object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(first) name:@"ssss" object:nil];;
    
     [[NSNotificationCenter defaultCenter] postNotificationName:@"ssss" object:nil];
}

- (void)first {
    NSLog(@"first");
}

- (void)second {
    NSLog(@"second");
}


- (void)test3 {
    
    NSLog(@"add observer Thread = %@",[NSThread currentThread]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(test3Receive) name:@"ssss" object:nil];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"post notify thread = %@",[NSThread currentThread]);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ssss" object:nil];
    });
    
    
}

- (void)test3Receive {
     NSLog(@"received notify Thread = %@",[NSThread currentThread]);
}



- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
