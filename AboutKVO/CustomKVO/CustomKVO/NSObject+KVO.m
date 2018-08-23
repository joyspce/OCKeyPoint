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

NSString *const kJWCKVOClassPrefix = @"JWCKVOClassPrefix_";
NSString *const kJWCKVOAssociatedObservers = @"JWCKVOAssociatedObservers";

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
    // 如果没有一个中间类
    if (![className hasPrefix:kJWCKVOClassPrefix]) {
        //生成一个中间类
        class = [self makeKvoClassWithOriginalClassName:className];
        object_setClass(self, class);//改变isa的指向
    }
    
    if (![self hasSelector:setterSel]) {
        const char *types = method_getTypeEncoding(setterMethod);
        class_addMethod(class, setterSel, (IMP)kvo_setter, types);
    }
    
    JWCObserverInfo *info = [[JWCObserverInfo alloc] initWithObserver:observer key:key blovk:block];
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void *)(kJWCKVOAssociatedObservers));
    if (!observers) {
        observers = [NSMutableArray array];
        objc_setAssociatedObject(self, (__bridge const void *)(kJWCKVOAssociatedObservers), observers, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [observers addObject:info];
    
    
}


- (void)jw_removeObserver:(NSObject *)observer forKey:(NSString *)key {
    NSMutableArray* observers = objc_getAssociatedObject(self, (__bridge const void *)(kJWCKVOAssociatedObservers));
    JWCObserverInfo *info = nil;
    for (JWCObserverInfo *inf in observers) {
        if (inf.observer == observer && [inf.key isEqualToString:key]) {
            info = inf;
            break;
        }
    }
    [observers removeObject:info];
}



static void kvo_setter(id self,SEL _cmd, id newValue) {
    NSString * setterName = NSStringFromSelector(_cmd);
    NSString *getterName = [self getterMethodFromSetter:setterName];
    if (!getterName) {
        NSString *reason = [NSString stringWithFormat:@"Object %@ does not have setter %@", self, setterName];
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:reason
                                     userInfo:nil];
        return;
    }
    
    id oldValue = [self valueForKey:getterName];
    
    struct objc_super superClazz = {
        .receiver = self,
        .super_class = class_getSuperclass(object_getClass(self))
    };
    void (*objc_msgSendSuperCasted)(void *, SEL, id) = (void *)objc_msgSendSuper;
    
    objc_msgSendSuperCasted(&superClazz, _cmd, newValue);
    
    NSMutableArray *observers = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kJWCKVOAssociatedObservers));
    
    for (JWCObserverInfo *info in observers) {
        if ([info.key isEqualToString:getterName]) {
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                info.block(self, getterName, oldValue, newValue);
            });
        }
    }
    
    
}



/**
 判断当前类中有没有 某个方法

 @param selector <#selector description#>
 @return <#return value description#>
 */
- (BOOL)hasSelector:(SEL)selector {
    
    Class class = object_getClass(self);
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(class, &count);
    for (NSInteger i = 0; i < count; i++) {
        SEL sel = method_getName(methodList[i]);
        if (selector == sel) {
            free(methodList);
            return YES;
        }
    }
    return NO;
}




/**
 生成一个中间类

 @param originalClazzName <#originalClazzName description#>
 @return <#return value description#>
 */
- (Class)makeKvoClassWithOriginalClassName:(NSString *)originalClazzName {
    NSString *kvoClassName = [kJWCKVOClassPrefix stringByAppendingString:originalClazzName];
    Class class = NSClassFromString(kvoClassName);
    if (class) {
        return class;
    }
    
    Class originalClass = object_getClass(self);
    Class kvoClass = objc_allocateClassPair(originalClass, kvoClassName.UTF8String, 0);
    
    Method classMethod = class_getInstanceMethod(originalClass, @selector(class));
    
    const char *types = method_getTypeEncoding(classMethod);
    class_addMethod(kvoClass, @selector(class), (IMP)kvo_class, types);
    objc_registerClassPair(kvoClass);
    
    return kvoClass;
    
    
}

static Class kvo_class(id self, SEL _cmd)
{
    return class_getSuperclass(object_getClass(self));
}



/**
 从setter方法中获取getter 方法

 @param setter <#setter description#>
 @return <#return value description#>
 */
- (NSString *)getterMethodFromSetter:(NSString *)setter {
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) {
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
    NSString *remainingLetters = [key substringFromIndex:1];
    
    // 3 把set 放在最前面 后面放 : 组成 setter 方法
    NSString *setter = [NSString stringWithFormat:@"set%@%@:",firstLetter,remainingLetters];
    
    return setter;
}






@end
