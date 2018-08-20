//
//  NSObject+Property.m
//  runtime-字典转模型
//
//  Created by JiWuChao on 2018/8/17.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "NSObject+Property.h"

#import <objc/runtime.h>

/**
 *  次结构体是一个属性列表的对象
 */
typedef struct property_t {
    const char *name;
    const char *attributes;
} *propertyStruct;


//保存foundation框架里面的类
static NSSet *foundationClasses_;

@implementation NSObject (Property)

/*
 typedef struct property_t *objc_property_t;
 
 struct property_t {
 const char *name;
 const char *attributes;
 };
 
 */

/**
 *  ,很多的类都不止一次调用了获取属性的方法,对于一个类来说,要获取它的全部属性,只要获取一次就够了.获取到后将结果缓存起来,下次就不必进行不必要的计算.
 */
static NSMutableDictionary *cachedProperties_;
+ (void)load
{
    cachedProperties_ = [NSMutableDictionary dictionary];
}


+ (NSSet *)foundationClasses
{
    if (foundationClasses_ == nil) {
        
        foundationClasses_ = [NSSet setWithObjects:
                              [NSURL class],
                              [NSDate class],
                              [NSValue class],
                              [NSData class],
                              [NSArray class],
                              [NSDictionary class],
                              [NSString class],
                              [NSAttributedString class], nil];
    }
    return foundationClasses_;
}


+ (BOOL)isClassFromFoundation:(Class)c{
    if (c == [NSObject class]) return YES;
    __block BOOL result = NO;
    [[self foundationClasses] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        if ([c isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}


+ (NSArray *)propertyList {

    NSMutableArray *cachedProperties = cachedProperties_[NSStringFromClass(self)];
    if (!cachedProperties) {//没有找到缓存、则初始化
        NSLog(@"%@调用了properties方法",[self class]);
        cachedProperties = [NSMutableArray array];
        //1 获取所有的属性
        unsigned int outCount = 0;
        objc_property_t *properties = class_copyPropertyList(self, &outCount);
        for (int i = 0; i < outCount; i++) {
            objc_property_t property = properties[i];
            JWCProperty *propertyObj = [JWCProperty propertyWithProperty:property];
            [cachedProperties addObject:propertyObj];
            //NSLog(@"%@,%@",propertyObj.name,propertyObj.type.typeClass);
        }
        //释放数组，修护内存泄露
        free(properties);
        //把所在对象的属性列表缓存下来
        cachedProperties_[NSStringFromClass(self)] = cachedProperties;
    }
    
    return cachedProperties;
    
    
//    for (NSInteger i = 0; i < count; i++) {
//        objc_property_t property = prprtys[i];
//
//        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
//        NSString *attribute = [NSString stringWithUTF8String:property_getAttributes(property)];
//
//        JWCProperty *propertyObj = [JWCProperty propertyWithProperty:property];
//
//        NSLog(@"propertyName = %@\n",name);
//        NSLog(@"propertyAttribute = %@\n",attribute);
//        [propertys addObject:propertyObj];
//        //释放数组，修护内存泄露
//        free(propertys);
//        //把所在对象的属性列表缓存下来
//        cachedProperties_[NSStringFromClass(self)] = cachedProperties;
//    }

    return cachedProperties;
}

@end
