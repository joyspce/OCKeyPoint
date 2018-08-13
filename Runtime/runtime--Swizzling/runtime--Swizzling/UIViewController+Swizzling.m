//
//  UIViewController+Swizzling.m
//  runtime--Swizzling
//
//  Created by JiWuChao on 2018/8/13.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "UIViewController+Swizzling.h"

#import <objc/runtime.h>


//第二中 Swizzing 方法
@implementation UIViewController (Swizzling)


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
        Method oriMethod = class_getInstanceMethod(aClass, @selector(viewWillAppear:));
        Method swizzingMethod = class_getInstanceMethod(aClass, @selector(customeViewWillAppear:));
       
        
        /*
         class_addMethod: 如果发现方法已经存在，会失败返回，也可以用来做检查用,我们这里是为了避免源方法没有实现的情况;如果方法没有存在,我们则先尝试添加被替换的方法的实现
         
         1.如果返回成功:则说明被替换方法没有存在.也就是被替换的方法没有被实现,我们需要先把这个方法实现,然后再执行我们想要的效果,用我们自定义的方法去替换被替换的方法. 这里使用到的是class_replaceMethod这个方法. class_replaceMethod本身会尝试调用class_addMethod和method_setImplementation，所以直接调用class_replaceMethod就可以了)
         
         2.如果返回失败:则说明被替换方法已经存在.直接将两个方法的实现交换即
         
         
         
         */
        BOOL didAddMethod = class_addMethod(aClass, @selector(viewWillAppear:), method_getImplementation(swizzingMethod), method_getTypeEncoding(swizzingMethod));
       /*
        如果类中不存在要替换的方法，那就先用class_addMethod和class_replaceMethod函数添加和替换两个方法的实现
        */
        if (didAddMethod) {
            class_replaceMethod(aClass, @selector(customeViewWillAppear:), method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
        } else {
            /*
             如果类中已经有了想要替换的方法，那么就调用method_exchangeImplementations函数交换了两个方法的 IMP，这是苹果提供给我们用于实现 Method Swizzling 的便捷方法
             */
            method_exchangeImplementations(oriMethod, swizzingMethod);
        }
    });
}


/**
该 方法的定义看似是递归调用引发死循环，其实不会的。因为[self customeViewWillAppear:anim消息会动态找到customeViewWillAppear:anim方法的实现，而它的实现已经被我们与viewWillAppear:方法实现进行了互换，所以这段代码不仅不会死循环，如果你把[customeViewWillAppear:anim]换成[self viewWillAppear:animated]反而会引发死循环

 @param anim <#anim description#>
 */
- (void)customeViewWillAppear:(BOOL) anim {
    [self customeViewWillAppear:anim];
    NSLog(@"我是自定义的 viewWillAppear");
}

@end
