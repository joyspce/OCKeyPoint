//
//  Father+Category.m
//  Category&&Extension
//
//  Created by JiWuChao on 2018/8/21.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "Father+Category.h"

#import <objc/runtime.h>

@implementation Father (Category)

+ (void)load {
    [[[Father alloc] init] goHome];
}

/**
 <#Description#>

 @param idNumber <#idNumber description#>
 */
- (void)setIdNumber:(NSString *)idNumber {
    objc_setAssociatedObject(self, @selector(idNumber), idNumber, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)idNumber {
    return objc_getAssociatedObject(self, @selector(idNumber));
}


- (void)goShoping {
    NSLog(@"Category中的方法：去购物");
}

- (void)goHome {
     NSLog(@"Category中的方法：回家");
}


@end
