//
//  NSObject+KVO.m
//  CustomKVO
//
//  Created by JiWuChao on 2018/8/22.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "NSObject+KVO.h"

#import <objc/runtime.h>

#import <objc/message.h>


/**
 存储被观察者的信息
 */
@interface JWCObserverInfo : NSObject

@property (nonatomic, weak) NSObject *observer;

@property (nonatomic, copy) NSString *key;

@property (nonatomic, copy) JWCObserverBlock block;

@end

@implementation JWCObserverInfo

- (instancetype) initWithObserver:(NSObject *)observer key:(NSString *)key blovk:(JWCObserverBlock) block {
    self = [super init];
    if (self) {
        self.observer = observer;
        self.key = key;
        self.block = block;
    }
    return self;
}

@end




@implementation NSObject (KVO)

- (void)jw_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(JWCObserverBlock)block {
    // 1 检查对象的类有没有相应的 setter方法。
    SEL setterSel = NSSelectorFromString([self setterMethodFromKey:key]);
    
    Method setterMethod = class_getInstanceMethod([self class], setterSel);
    
    if (!setterMethod) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have a setter for key %@", self, key];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        
        return;
    }
    
    // 2. 检查对象 isa 指向的类是不是一个 KVO 类。如果不是，新建一个继承原来类的子类，并把 isa 指向这个新建的子类

    
    
    Class class = object_getClass(self);
    
    NSString *className = NSStringFromClass(class);
    
    
    
}


- (void)jw_removeObserver:(NSObject *)observer forKey:(NSString *)key {
    
}



/**
 从setter方法中获取getter 方法

 @param setter <#setter description#>
 @return <#return value description#>
 */
- (NSString *)getterMethodFromSetter:(NSString *)setter {
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] != [setter hasSuffix:@":"]) {
        return nil;
    }
    // 删除 set 和 : 并把大写改为小写
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    NSString *firstLetter = [[key substringToIndex:1] lowercaseString];
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstLetter];
    return key;
}

//根据key 拼接成 setter方法
- (NSString *)setterMethodFromKey:(NSString *)key {
    if (key.length <= 0) {
        return nil;
    }
    // setter的方法格式是 setXxx:
    //1 获取首字母 并且转换成大写
    NSString *firstLetter = [[key substringToIndex:1] uppercaseString];
    //2  获取剩余的字母
    NSString *remainingLetters = [key substringToIndex:1];
    
    // 3 把set 放在最前面 后面放 : 组成 setter 方法
    NSString *setter = [NSString stringWithFormat:@"set%@%@:",firstLetter,remainingLetters];
    
    return setter;
}






@end
