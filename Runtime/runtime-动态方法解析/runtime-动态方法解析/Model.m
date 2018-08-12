//
//  Model.m
//  runtime-动态方法解析
//
//  Created by JiWuChao on 2018/8/12.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "Model.h"

#import <objc/runtime.h>

@interface Model () {
    NSString *_name;
}



@end


@implementation Model


/**
 @dynamic 表示 name 不自动生成 get 和 set 方法 需要手动实现
 */
@dynamic name;


/**
 此方法在外部方法表中没有找到方法的实现 IMP 则在消息进行转发前，调用的一个方法，如果在此方法中有返回方法的实现 IMP 则去执行，如果此方法没有实现 则会调用 super 的resolveInstanceMethod 如果 super 也没有返回 IMP 则进入消息转发流程。此方法是在消息转发前唯一一次动态添加方法的机会

 @param sel <#sel description#>
 @return <#return value description#>
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(setName:)) {
        class_addMethod([self class], sel, (IMP)setName, "v@:@");
        return YES;
    }
    
    if (sel == @selector(name)) {
        class_addMethod([self class], sel, (IMP)getName, "@@:");
    }
    
    return [super resolveInstanceMethod:sel];
}

void setName(id self, SEL _cmd, NSString* name)
{
    
    if (((Model*)self)->_name != name) {
        ((Model *)self)->_name = [name copy];
    }
}
        
NSString* getName(id self, SEL _cmd)
{
    return ((Model *)self)->_name;
}
        
@end
