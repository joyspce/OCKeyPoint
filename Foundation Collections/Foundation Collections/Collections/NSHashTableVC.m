//
//  NSHashTableVC.m
//  Foundation Collections
//
//  Created by JiWuChao on 2018/8/28.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "NSHashTableVC.h"

#import "Model.h"

#import "Human.h"

#import "HumanWeekReference.h"

@interface NSHashTableVC ()

@property(nonatomic,strong) Human *man;

@property (nonatomic, strong) HumanWeekReference *human ;

@end

/*
 -------NSHashTable ------
 
  效仿了 NSSet，但在对象/内存处理时更加的灵活。可以通过自定义 CFSet 的回调获得 NSHashTable 的一些特性，哈希表可以保持对对象的弱引用并在对象被销毁之后正确的将其移除，有时候如果手动在 NSSet 中添加的话，想做到这个是挺恶心的一件事。它是默认可变的 — 并且这个类没有相应的不可变版本。
 
 NSHashTable 有 ObjC 和原始的 C API，C API 可以用来存储任意对象。苹果在 10.5 Leopard 系统中引入了这个类，但是 iOS 的话直到最近的 iOS 6 中才被加入。足够有趣的是它们只移植了 ObjC API；更多强大的 C API 没有包括在 iOS 中。
 
 NSHashTable 可以通过 initWithPointerFunctions:capacity: 进行大量的设置 — 我们只选取使用预先定义的 hashTableWithOptions: 这一最普遍的使用场景。其中最有用的选项有利用 weakObjectsHashTable 来使用其自身的构造函数。
 
 
 ----- NSPointerFunctions ---------
 
 
 这些指针函数可以被用在 NSHashTable，NSMapTable和 NSPointerArray 中，定义了对存储在这个集合中的对象的获取和保留行为。这里只介绍最有用的选项。完整列表参见 NSPointerFunctions.h。
 
 有两组选项。内存选项决定了内存管理，个性化定义了哈希和相等。
 
 NSPointerFunctionsStrongMemory 创建了一个r etain/release 对象的集合，非常像常规的 NSSet 或 NSArray。
 
 NSPointerFunctionsWeakMemory 使用和 __weak 等价的方式来存储对象并自动移除被销毁的对象。
 
 NSPointerFunctionsCopyIn 在对象被加入到集合前拷贝它们。
 
 NSPointerFunctionsObjectPersonality 使用对象的 hash 和 isEqual: (默认)。
 
 NSPointerFunctionsObjectPointerPersonality 对于 isEqual: 和 hash 使用直接的指针比较。
 
 
 
 --------- NSHashTable 性能特征 --------
 类 / 时间 [ms]    1.000.000 elements
 NSHashTable, adding    2511.96
 NSMutableSet, adding    1423.26
 NSHashTable, random access    3.13
 NSMutableSet, random access    4.39
 NSHashTable, containsObject    6.56
 NSMutableSet, containsObject    6.77
 NSHashTable, NSFastEnumeration    39.03
 NSMutableSet, NSFastEnumeration    30.43
 
 如果你只是需要 NSSet 的特性，请坚持使用 NSSet。NSHashTable 在添加对象时花费了将近2倍的时间，但是其他方面的效率却非常相近。
 
 NSHashTable 与 NSSet 的比较
 
 NSHashTable 是 NSSet 的通用版本，和 NSSet / NSMutableSet 不同的是，NSHashTable 具有下面这些特性：
 
 NSSet / NSMutableSet 持有成员的强引用，通过 hash 和 isEqual: 方法来检测成员的散列值和相等性。
 NSHashTable 是可变的，没有不可变的对应版本。
 NSHashTable 可以持有成员的弱引用。
 NSHashTable 可以在加入成员时进行 copy 操作。
 NSHashTable 可以存储任意的指针，通过指针来进行相等性和散列检查。
 
 */


@implementation NSHashTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self strongRefrence];
    [self weakReference];
}




/**
 
 问题：
    NSArray/NSMutableArray,NSDictionary/NSMutableDictionary,NSSet/NSMutableSet 容器类有一个特性
    将对象添加到上述容器时，会对该对象的引用技术+1
 
 证明：
    举例：Human 类
 
 @property (nonatomic, copy) NSString *name;
 
 @property (nonatomic, assign) NSInteger age;
 
 @property (nonatomic, strong) NSMutableArray <Human *>*family;
 
 其中Human 强引用 family ，而family 有包含Human类 （证明其强引用Human）
 
 - (instancetype)initWithName:(NSString *)name withAge:(NSInteger)age {
     Human *model = [[Human alloc] init];
     model.name = name;
     model.age = age;
     model.family = [[NSMutableArray alloc] init];
     //family 中包含 Human类
     [model.family addObject:model];
     return model;
 }
 
 结果：
    当NSHashTableVC pop出去 调用NSHashTableVC本类的dealloc ，按照正常情况下 会调用 Human的dealloc
 然而，由于Human类 强引用family 而family有强引用 human对象 导致循环引用，所以Human对象无法释放，造成内存泄漏
 
 解决方法：
 
 
 
 */

- (void)strongRefrence {
    Human *man1 = [Human initWithName:@"张三"];
    NSLog(@"man1.family = %@",man1.family);
}


- (void)weakReference {
    self.human = [HumanWeekReference initWithName:@"张三"];
    NSLog(@"human.name = %@",self.human.family);
}



- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"over");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
