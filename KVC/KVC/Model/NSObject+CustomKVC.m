//
//  NSObject+CustomKVC.m
//  KVC
//
//  Created by JiWuChao on 2018/9/6.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "NSObject+CustomKVC.h"

#import <objc/runtime.h>

@implementation NSObject (CustomKVC)

- (void)setCtmValue:(id)value forKey:(NSString *)key {
    if (key == nil || key.length == 0) {
        return;
    }
    if ([value isKindOfClass:[NSNull class]]) {
        [self setNilValueForKey:key];// //如果需要完全自定义，那么这里需要写一个setMyNilValueForKey，但是必要性不是很大，就省略了
        return;
    }
    
    if (![value isKindOfClass:[NSObject class]]) {
        @throw @"must be a NSObjec type";
        return;
    }
    
    NSString *funcName = [NSString stringWithFormat:@"set%@:",key.capitalizedString];
    if ([self respondsToSelector:NSSelectorFromString(funcName)]) {//默认优先调用set方法
        [self performSelector:NSSelectorFromString(funcName) withObject:value];
        return;
    }
    unsigned int count;
    BOOL flag = false;
    Ivar *vars = class_copyIvarList([self class], &count);
    for (NSInteger i = 0; i < count; i++) {
        Ivar var = vars[i];
        NSString *keyName = [[NSString stringWithCString:ivar_getName(var) encoding:NSUTF8StringEncoding] substringFromIndex:1];
        if ([keyName isEqualToString:[NSString stringWithFormat:@"_%@",key]]) {
            flag = true;
            object_setIvar(self, var, value);
            break;
        }
        
        if ([keyName isEqualToString:key]) {
            flag = true;
            object_setIvar(self, var, value);
        }
    }
    if (!flag) {
        [self setValue:value forUndefinedKey:key];
    }
    
}


- (id)ctmValueforKey:(NSString *)key {
    if (key == nil || key.length == 0) {
        return nil;
    }
    
    NSString *funcName = [NSString stringWithFormat:@"gett%@:",key.capitalizedString];
    if ([self respondsToSelector:NSSelectorFromString(funcName)]) {//默认优先调用set方法
        return [self performSelector:NSSelectorFromString(funcName)];
    }
    
    unsigned int count;
    BOOL flag = false;
    Ivar *vars = class_copyIvarList([self class], &count);
    
    for (NSInteger i = 0; i < count; i++) {
        Ivar var = vars[i];
        NSString *keyName = [[NSString stringWithCString:ivar_getName(var) encoding:NSUTF8StringEncoding] substringFromIndex:1];
        
        if ([keyName isEqualToString:[NSString stringWithFormat:@"_%@",key]]) {
            flag = true;
            return object_getIvar(self, var);
            break;
        }
        
        if ([keyName isEqualToString:key]) {
            flag = true;
            return object_getIvar(self, var);
            break;
        }
    }
    
    if (!flag) {
        [self valueForUndefinedKey:key];
    }
    
    return nil;
}


@end
