//
//  Father.m
//  runtime消息转发1-动态方法解析
//
//  Created by JiWuChao on 2018/8/12.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "Father.h"

#import <objc/runtime.h>

@implementation Father


/**
 手动添加 gotoWork的实现 IMP

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
    NSLog(@"我去上班了");
}

- (void)work {
    NSLog(@"我去上班了");
}


@end
