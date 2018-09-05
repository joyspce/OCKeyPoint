//
//  KVCContainerModel.m
//  KVC
//
//  Created by JiWuChao on 2018/9/5.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "KVCContainerModel.h"

@interface KVCContainerModel() {
        NSMutableArray *_error;
}



@end


@implementation KVCContainerModel


/*
    在调用 [[self mutableArrayValueForKey:@"mArray"] addObject:@"2"] 增加
    addObject 方法调用顺序是 1 如果1 没有则 调用 2
 
    在调用 [[self mutableArrayValueForKeyPath:@"mArray"] removeLastObject]; 删除
    removeLastObject 方法的调用顺序是 3 如果没有3 则调用 4
 
 */


- (instancetype)init
{
    self = [super init];
    if (self) {
        _mArray = [[NSMutableArray alloc] init];
        [self addObserver:self forKeyPath:@"mArray" options:NSKeyValueObservingOptionNew context:NULL];
        _errorArray = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"change = %@" ,change);
}

//不会触发kvo
- (void)addObj {
    NSLog(@"调用了 %s",__func__);
    [_mArray addObject:@"1"];
    
}
//可以触发kvo
- (void)addObjObserver {
    NSLog(@"调用了 %s",__func__);
    [[self mutableArrayValueForKey:@"mArray"] addObject:@"2"];
}

//可以触发kvo
- (void)removeObj{
    NSLog(@"调用了 %s",__func__);
    [[self mutableArrayValueForKeyPath:@"mArray"] removeLastObject];
}




/*
 - (NSMutableArray *)mutableArrayValueForKey:(NSString *)key;
    该方法返回一个可变有序数组，如果调用该方法，KVC的搜索顺序如下
 */


//--------------------- 第一步


/*
 搜索insertObject:in<Key>AtIndex: , removeObjectFrom<Key>AtIndex: 或者 insert<Key>AdIndexes , remove<Key>AtIndexes 格式的方法
 如果至少找到一个insert方法和一个remove方法，那么同样返回一个可以响应NSMutableArray所有方法代理集合(类名是NSKeyValueFastMutableArray2)，那么给这个代理集合发送NSMutableArray的方法，以insertObject:in<Key>AtIndex: , removeObjectFrom<Key>AtIndex: 或者 insert<Key>AdIndexes , remove<Key>AtIndexes组合的形式调用。还有两个可选实现的接口：replaceOnjectAtIndex:withObject:,replace<Key>AtIndexes:with<Key>:。
 
 */


 /*
 //1
- (void)insertObject:(NSString *)object inMArrayAtIndex:(NSInteger)index {
    NSLog(@"调用了 %s",__func__);
    [_mArray insertObject:object atIndex:index];
}

// 2
- (void)insertMArray:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
    [_mArray addObjectsFromArray:array];
}

// 3
- (void)removeObjectFromMArrayAtIndex:(NSInteger)index {
    NSLog(@"调用了 %s",__func__);
    [_mArray removeObjectAtIndex:index];
}
// 4
- (void)removeMArrayAtIndexes:(NSIndexSet *)indexes {
    [_mArray removeObjectsAtIndexes:indexes];
}
*/
//-----------------第二步--------------

/*
 如果上步的方法没有找到，则搜索set<Key>: 格式的方法，如果找到，那么发送给代理集合的NSMutableArray最终都会调用set<Key>:方法。 也就是说，mutableArrayValueForKey:取出的代理集合修改后，用set<Key>: 重新赋值回去去。这样做效率会低很多。所以推荐实现上面的方法。
 
 */

- (void)setMArray:(NSMutableArray *)mArray {
    _mArray = mArray;
}



// ---------- 第三步
/*
    如果上一步的方法还还没有找到，再检查类方法+ (BOOL)accessInstanceVariablesDirectly,如果返回YES(默认行为)，会按_<key>,<key>,的顺序搜索成员变量名，如果找到，那么发送的NSMutableArray消息方法直接交给这个成员变量处理。
 
   *******  重点 *******：比如
 - (void)addObjObserver {
    NSLog(@"调用了 %s",__func__);
    [[self mutableArrayValueForKey:@"errorArray"] addObject:@"2"];
 }
 
 key 为 @"errorArray" 那么 @"errorArray" 这个key 没有响应的 insertObject:in<Key>AtIndex: , removeObjectFrom<Key>AtIndex: 或者 insert<Key>AdIndexes , remove<Key>AtIndexes 这些方法 那么 则会触发
  + (BOOL)accessInstanceVariablesDirectly
 */




//key 是 errorArray 不会触发 accessInstanceVariablesDirectly 一系列方法 但是 把key 设为 “error”是会触发 因为 “error”没有这个key
- (void)addErrorArray {
    [[self mutableArrayValueForKey:@"error"] addObject:@"21"];
}



+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {
    _errorArray = value;
}

// ------------ 第四步

/*
 
 如果还是找不到，则调用valueForUndefinedKey:。
 */



- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}


/*
 关于mutableArrayValueForKey:的适用场景:
 
 
    一般是用在对NSMutableArray添加Observer上。如果对象属性是个NSMutableArray、NSMutableSet、NSMutableDictionary等集合类型时，你给它添加KVO时，你会发现当你添加或者移除元素时并不能接收到变化。因为KVO的本质是系统监测到某个属性的内存地址或常量改变时，会添加上- (void)willChangeValueForKey:(NSString *)key和
    - (void)didChangeValueForKey:(NSString *)key方法来发送通知，所以一种解决方法是手动调用者两个方法，但是并不推荐，你永远无法像系统一样真正知道这个元素什么时候被改变。另一种便是利用使用mutableArrayValueForKey:了。
 
 */

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"mArray"];
}



@end
