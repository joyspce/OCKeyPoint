//
//  Grandfather.m
//  runtime 消息转发2--快速转发
//
//  Created by JiWuChao on 2018/8/12.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "Grandfather.h"

#import <objc/runtime.h>

@implementation Grandfather

/**
 由于子类的方法没有实现gotoWork 在子类的resolveInstanceMethod 方法中调用了  [super resolveInstanceMethod:sel]; 所以找到了这里 如果这里不手动添加 gotoWork 的 imp 则会出现崩溃
 
 ** 此resolveInstanceMethod的实现也可以放在 其子类 Father 中那么在 Father 中不需要调用return [super resolveInstanceMethod:sel];  **
 
 @param sel <#sel description#>
 @return <#return value description#>
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(gotoWork)) {
        class_addMethod([self class], sel, (IMP)work, "@@:");
    }
    return NO;
}


void work (id self, SEL _cmd) {
    NSLog(@"爷爷:我去上班了");
}


@end
