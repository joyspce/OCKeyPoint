//
//  ViewController.m
//  NSOperationCommunication
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
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperationWithBlock:^{
        for (NSInteger i = 0; i< 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"thread - %@",[NSThread currentThread]);
        }
        
        // 回到主线程
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            for (NSInteger i = 0; i< 2; i++) {
                [NSThread sleepForTimeInterval:1];
                NSLog(@"main thread - %@",[NSThread currentThread]);
            }
        }];
        
    }];
    
}


@end
