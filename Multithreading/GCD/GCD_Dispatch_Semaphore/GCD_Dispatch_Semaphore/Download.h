//
//  Download.h
//  GCD_Dispatch_Semaphore
//
//  Created by JiWuChao on 2018/9/28.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Download : NSObject

+ (instancetype)shared;

+ (void)downloadData:(void (^)(BOOL success))complate;

@end

