//
//  ViewController.m
//  gcdCreate
//
//  Created by JiWuChao on 2018/9/25.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     dispatch_queue_create 生成队列 无论是并发队列还是串行队列 其都是默认优先级
     
     */
    // 并发队列
    dispatch_queue_t customQueue = dispatch_queue_create("com.jiwuchao.GCD_Queue", DISPATCH_QUEUE_CONCURRENT);
    // 串行队列
    dispatch_queue_t customSerial = dispatch_queue_create("com.jiwuchao.gcd_queue.serial", DISPATCH_QUEUE_SERIAL);
    
    //指定
    
    dispatch_queue_t globleBackgtoundQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    //表示customQueue 使用的优先级和 globleBackgtoundQueue 的优先级一样
    dispatch_set_target_queue(customQueue, globleBackgtoundQueue);;
    
    
    //主队列
    dispatch_queue_t mainDispathQueue = dispatch_get_main_queue();
    
    //全局队列
    //高优先级
    dispatch_queue_t globlehighQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    //默认优先级
    dispatch_queue_t globleDefaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //低优先级
    dispatch_queue_t globleLowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    //后台
    dispatch_queue_t globleBackgtoundQueue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
}


@end
