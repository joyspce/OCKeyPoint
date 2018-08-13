//
//  Father+category.m
//  runtime --Associated
//
//  Created by JiWuChao on 2018/8/13.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "Father+category.h"

#import <objc/runtime.h>

@implementation Father (category)

//---------1. 设置关联对象-------
/**
 objc_setAssociatedObject : 设置关联对象
 objc_getAssociatedObject : 获取关联对象
 objc_removeAssociatedObjects : 移除某个对象的所有关联对象
 */
- (void)setName:(NSString *)name {
    
     /**
      object : 需要设置关联对象的对象, id类型
      key : 关联对象的key, const void *类型 (详细请看下文第4点)
      value : 关联对象的值, id类型
      policy : 关联对象的策略, objc_AssociationPolicy类型

      objc_setAssociatedObject(id _Nonnull object, const void * _Nonnull key,
      id _Nullable value, objc_AssociationPolicy policy)
      */
     objc_setAssociatedObject(self, @selector(name), name, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


//---------2. 获取关联对象-------

- (NSString *)name {
    
    /**
     object : 获取关联对象的对象, id类型
     key : 关联对象的key, const void *类型
     
     objc_getAssociatedObject(id _Nonnull object, const void * _Nonnull key)
     */
    return objc_getAssociatedObject(self, @selector(name));
}

- (void)setAge:(NSNumber *)age {
    objc_setAssociatedObject(self, @selector(age), age, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)age {
    
    return objc_getAssociatedObject(self, @selector(age));
}

//---------3. 移除某个对象的所有关联对象-------

/*
 
 object : 需要移除所有关联对象的对象, id类型
 
 void objc_removeAssociatedObjects(id object)
 
 注: 这个函数是用来移除对象的所有关联对象, 而非移除对象的某个关联对象. 意思是如果要移除对象的某个关联对象, 应该使用objc_setAssociatedObject对参数value置nil.
 */



@end
