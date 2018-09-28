//
//  ViewController.m
//  GCD_Dispatch_apply
//
//  Created by JiWuChao on 2018/9/28.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self dispatchApply];
}

- (void)dispatchApply {
//    第一个参数为重复次数；
//    第二个参数为追加对象的Dispatch Queue；
//    第三个参数为追加的操作，追加的Block中带有参数，这是为了按第一个参数重复追加Block并区分各个Block而使用。
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.wuchaoji.www", DISPATCH_QUEUE_CONCURRENT);
     dispatch_queue_t serialqueue = dispatch_queue_create("com.wuchaoji.www", DISPATCH_QUEUE_SERIAL);
    dispatch_apply(5, concurrentQueue, ^(size_t index) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"concurrentQueue index = %ld",index);
    });
    NSLog(@"concurrentQueue 执行完");
    
    
    dispatch_apply(5, serialqueue, ^(size_t index) {
        NSLog(@"serialqueue index = %ld",index);
    });
    NSLog(@"serialqueue 执行完");
    /*
     输出
     concurrentQueue index = 0
     concurrentQueue index = 2
     concurrentQueue index = 1
     concurrentQueue index = 3
     concurrentQueue index = 4
     concurrentQueue 执行完
     serialqueue index = 0
     serialqueue index = 1
     serialqueue index = 2
     serialqueue index = 3
     serialqueue index = 4
     serialqueue 执行完
     
     concurrentQueue 无序
     serialqueue 有序
     */
    
}



@end
