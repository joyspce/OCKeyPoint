//
//  Father.m
//  runtime消息转发1-动态方法解析
//
//  Created by JiWuChao on 2018/8/12.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "Father.h"

#import <objc/runtime.h>

#import "Mother.h"

@implementation Father


/**
 此方法在外部方法表中没有找到方法的实现 IMP 则在消息进行转发前，调用的一个方法，如果在此方法中有返回方法的实现 IMP 则去执行，如果此方法没有实现 则会调用 super 的resolveInstanceMethod 如果 super 也没有返回 IMP 则进入消息转发流程。此方法是在消息转发前唯一一次动态添加方法的机会

 ***此方法没有动态添加 gotowork 的 imp 则 向父类Grandfather 查找***
 
 @param sel <#sel description#>
 @return <#return value description#>
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(gotoWork)) {//如果是gotoWork 方法则向父类查找
        return [super resolveInstanceMethod:sel];
    }
    //如果是gotoWork 以外的方法 则不动态添加，则会进入下一步 消息快速转发流程
    return NO;
}


/**
 快速转发 ：
 *注意*：千万不能返回 self ，假如返回 self 则会进入死循环

 @param aSelector <#aSelector description#>
 @return <#return value description#>
 */
- (id)forwardingTargetForSelector:(SEL)aSelector {
    //如果是goHomeToCook 方法则转发给 Mother 类
    
    if (aSelector == @selector(goHomeToCook)) {
        Mother *m = [[Mother alloc]init];
        return m;
    }
    //如果本类没有做快速转发则向父类查找
    return [super forwardingTargetForSelector:aSelector];
}


@end
