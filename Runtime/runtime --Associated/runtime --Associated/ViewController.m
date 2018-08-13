//
//  ViewController.m
//  runtime --Associated
//
//  Created by JiWuChao on 2018/8/13.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "Father.h"

#import "Father+category.h"


/*
    Associated Objects-为分类添加属性
 
 //---------1. 设置关联对象-------
 /**
 objc_setAssociatedObject : 设置关联对象
 objc_getAssociatedObject : 获取关联对象
 objc_removeAssociatedObjects : 移除某个对象的所有关联对象
 */
//- (void)setName:(NSString *)name {
//
//    /**
//     object : 需要设置关联对象的对象, id类型
//     key : 关联对象的key, const void *类型 (详细请看下文第4点)
//     value : 关联对象的值, id类型
//     policy : 关联对象的策略, objc_AssociationPolicy类型
//
//     objc_setAssociatedObject(id _Nonnull object, const void * _Nonnull key,
//     id _Nullable value, objc_AssociationPolicy policy)
//     */
//    objc_setAssociatedObject(self, @selector(name), name, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}


//---------2. 获取关联对象-------

//- (NSString *)name {
//
//    /**
//     object : 获取关联对象的对象, id类型
//     key : 关联对象的key, const void *类型
//
//     objc_getAssociatedObject(id _Nonnull object, const void * _Nonnull key)
//     */
//    return objc_getAssociatedObject(self, @selector(name));
//}

//- (void)setAge:(NSNumber *)age {
//    objc_setAssociatedObject(self, @selector(age), age, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}

//- (NSNumber *)age {
//
//    return objc_getAssociatedObject(self, @selector(age));
//}

//---------3. 移除某个对象的所有关联对象-------

/*
 
 object : 需要移除所有关联对象的对象, id类型
 
 void objc_removeAssociatedObjects(id object)
 
 注: 这个函数是用来移除对象的所有关联对象, 而非移除对象的某个关联对象. 意思是如果要移除对象的某个关联对象, 应该使用objc_setAssociatedObject对参数value置nil.
 */


    // 三个问题：

    /*
    1 关联对象被存储在什么地方，是不是存放在被关联对象本身的内存中？
     
    答： 关联对象与被关联对象本身的存储并没有直接的关系，它是存储在单独的哈希表中的；
    2 关联对象的五种关联策略有什么区别，有什么坑？
     
    答： 关联对象的五种关联策略与属性的限定符非常类似，在绝大多数情况下，我们都会使用 OBJC_ASSOCIATION_RETAIN_NONATOMIC 的关联策略，这可以保证我们持有关联对象；
     
    3 关联对象的生命周期是怎样的，什么时候被释放，什么时候被移除？
     
    答： 关联对象的释放时机与移除时机并不总是一致，比如实验中用关联策略 OBJC_ASSOCIATION_ASSIGN 进行关联的对象，很早就已经被释放了，但是并没有被移除，而再使用这个关联对象时就会造成 Crash
     http://blog.leichunfeng.com/blog/2015/06/26/objective-c-associated-objects-implementation-principle/
     */

 
// */

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Father *f = [[Father alloc] init];
    f.name = @"张三";
    f.age = @(11);
    NSLog(@"father.name = %@",f.name);
    NSLog(@"father.age = %@",f.age);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
