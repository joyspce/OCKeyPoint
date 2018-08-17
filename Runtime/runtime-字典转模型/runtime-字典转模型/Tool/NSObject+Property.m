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
    
    
    unsigned int count = 0;
    
    objc_property_t *prprtys = class_copyPropertyList([self class], &count);
    
    NSMutableArray *propertys = [[NSMutableArray alloc] initWithCapacity:count];
    
    for (NSInteger i = 0; i < count; i++) {
        objc_property_t property = prprtys[i];
        
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        NSString *attribute = [NSString stringWithUTF8String:property_getAttributes(property)];
        
        JWCProperty *propertyObj = [JWCProperty propertyWithProperty:property];
        
        NSLog(@"propertyName = %@\n",name);
        NSLog(@"propertyAttribute = %@\n",attribute);
        [propertys addObject:propertyObj];
    }

    return propertys.copy;
}

@end
