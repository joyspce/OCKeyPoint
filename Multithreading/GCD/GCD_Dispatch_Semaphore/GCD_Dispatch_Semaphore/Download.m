//
//  Download.m
//  GCD_Dispatch_Semaphore
//
//  Created by JiWuChao on 2018/9/28.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "Download.h"

@implementation Download


+ (void)downloadData:(void (^)(BOOL))complate {
    [[[self alloc]init ] downloadData:complate];
}

- (void)downloadData:(void (^)(BOOL))complate {
    
    NSLog(@"1 downloading currentThread - > %@",[NSThread currentThread]);
    [NSThread sleepForTimeInterval:5];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"2 download done currentThread - > %@",[NSThread currentThread]);
            if (complate) {
                complate(YES);
            }
        });
    });
    
}

- (void)afterLoad:(void (^)(BOOL))complate {
    
}


@end
