//
//  UIViewController+SwizzlingMethodThird.m
//  runtime--Swizzling
//
//  Created by JiWuChao on 2018/8/20.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "UIViewController+SwizzlingMethodThird.h"

#import <objc/runtime.h>

typedef id (*_IMP)(id,SEL, ...);

/*
    第三种方法 直接交换imp
 */

@implementation UIViewController (SwizzlingMethodThird)

/*
 Swizzling 应该在+load方法中实现，因为+load是在一个类最开始加载时调用。dispatch_once是GCD中的一个方法，它保证了代码块只执行一次，并让其为一个原子操作，线程安全是很重要的
 
 */
+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        /*
         //When swizzling a class method, use the following:
         // Class aClass = object_getClass((id)self);
         object_getClass((id)self) 与 [self class] 返回的结果类型都是 Class,但前者为元类,后者为其本身,因为此时 self 为 Class 而不是实例
         */
        
        Class aClass = [self class];
        Method oriMethod = class_getInstanceMethod(aClass, @selector(viewDidLoad));
        _IMP viewDidLoad_imp =  (_IMP)method_getImplementation(oriMethod);
        method_setImplementation(oriMethod, imp_implementationWithBlock(^(id target ,SEL action ){
            viewDidLoad_imp(target,@selector(viewDidLoad));
            NSLog(@"自定义方法");
        }));
        
    });
}

@end
