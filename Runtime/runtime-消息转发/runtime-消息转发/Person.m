//
//  Person.m
//  重定向
//
//  Created by JiWuChao on 2018/8/9.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "Person.h"

#import <objc/runtime.h>

#import "Student.h"

@implementation Person

- (void)whoImI {
    NSLog(@"消息已经转发给我了，哈哈哈");
}

/*
    // 当调用eatApple 时 由于eatApple 没有实现 则会进入转发流程
    1 + (BOOL)resolveInstanceMethod:(SEL)sel
    2 - (id)forwardingTargetForSelector:(SEL)aSelector
    3 - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
    4 - (void)forwardInvocation:(NSInvocation *)anInvocation
    5 - (void)doesNotRecognizeSelector:(SEL)aSelector
 */

//第1步

/*
    因为当 Runtime 系统在Cache和方法分发表中（包括超类）找不到要执行的方法时，
   Runtime会调用resolveInstanceMethod:或resolveClassMethod:
 来给程序员一次动态添加方法实现的机会
 */

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"%s,%@\n",__func__,NSStringFromSelector(sel));
    if ([NSStringFromSelector(sel) isEqualToString:@""]) {
        SEL whoImi = NSSelectorFromString(@"whoImI");
        IMP selIMP = class_getMethodImplementation(self, whoImi);
        const char *types = method_getTypeEncoding(class_getInstanceMethod(self, whoImi));
        class_addMethod([self class], sel, selIMP, types);
        //class_addMethod(Class  _Nullable __unsafe_unretained cls, SEL  _Nonnull name, IMP  _Nonnull imp, const char * _Nullable types)
        //动态添加一个方法 当调用 eatApple 时
        return YES;
    }
    return [super resolveInstanceMethod:sel];
}
//第2步
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"%s",__func__);
    
    if ([NSStringFromSelector(aSelector) isEqualToString:@"eatApple"]) {
        Student *std = [[Student alloc] init];
        return std;
    }
    
    return [super forwardingTargetForSelector:aSelector];
}
//第3步 获取方法签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"%s",__func__);
    //获取对应的aSelector 签名
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        if ([Student instanceMethodForSelector:aSelector]) {
            signature = [Student instanceMethodSignatureForSelector:aSelector];
        }
    }
    return signature;
}

//第4步
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"%s",__func__);
  
    if ([Student instanceMethodSignatureForSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:[[Student alloc] init]];
    } else {
        [super forwardInvocation:anInvocation];
    }
    
}
//第5步
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    NSLog(@"%s",__func__);
}






@end
