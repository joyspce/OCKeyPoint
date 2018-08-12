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

#import "Son.h"

@implementation Father

//
///**
// 此方法在外部方法表中没有找到方法的实现 IMP 则在消息进行转发前，调用的一个方法，如果在此方法中有返回方法的实现 IMP 则去执行，如果此方法没有实现 则会调用 super 的resolveInstanceMethod 如果 super 也没有返回 IMP 则进入消息转发流程。此方法是在消息转发前唯一一次动态添加方法的机会
//
// ***此方法没有动态添加 gotowork 的 imp 则 向父类Grandfather 查找***
//
// @param sel <#sel description#>
// @return <#return value description#>
// */
//+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    if (sel == @selector(gotoWork)) {//如果是gotoWork 方法则向父类查找
//        return [super resolveInstanceMethod:sel];
//    }
//    //如果是gotoWork 以外的方法 则不动态添加，则会进入下一步 消息重定向（注意：重定向还没有进入消息转发流程）
//    return NO;
//}
//
//
///**
// 快速转发：重定向 ：此时还没有进入消息转发流程
// *注意*：千万不能返回 self ，假如返回 self 则会进入死循环
//
// @param aSelector <#aSelector description#>
// @return <#return value description#>
// */
//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    //如果是goHomeToCook 方法则转发给 Mother 类
//
//    if (aSelector == @selector(goHomeToCook)) {
//        Mother *m = [[Mother alloc]init];
//        return m;
//    }
//    //如果本类没有做快速转发则向父类查找
//    return [super forwardingTargetForSelector:aSelector];
//}


/*
   1  + (BOOL)resolveInstanceMethod:(SEL)sel 添加方法
   2 - (id)forwardingTargetForSelector:(SEL)aSelector  重定向 快速转发
  如果上面两个方法都没有实现则 开始真正进入转发机制
 
 注意：
 1 可以为多个 selector 实现一个方法实现。 也可以将一个 selector 转发给多个对象。
 
 2 methodSignatureForSelector 和 forwardInvocation 必须一起重写才会实现消息转发。
 3 系统会自动实现 NSInvocation *anInvocation = [[NSInvocation invocationWithMethodSignature:signature];
 4 得到的 anInvocation 被传入了 方法
 - (void)forwardInvocation:(NSInvocation *)invocation
 
 ------------------------辨析---------------------
 forwardingTargetForSelector 和 forwardInvocation 都是作消息转发 有什么区别？
 答：1， forwardingTargetForSelector仅支持一个对象的返回，也就是说消息只能被转发给一个对象
    2，forwardInvocation可以将消息同时转发给任意多个对象
 
 */



/**
 方法选择器


 @param aSelector 方法签名

 @return 通过类型编码直接创建方法签名： [NSMethodSignature signatureWithObjcTypes:"v@:"];
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature = [NSMethodSignature methodSignatureForSelector:aSelector];
    if (!methodSignature){
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation{
    SEL sel = [anInvocation selector];
    if (sel == @selector(goHomeToCook)){
        //一个 selector 转发给多个对象
        [anInvocation invokeWithTarget:[[Mother alloc] init]];
        [anInvocation invokeWithTarget:[[Son alloc]init]];
    }
}

@end
