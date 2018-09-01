
## NSSet&&NSMutableSet

### 定义
&emsp;NSSet 和它的可变变体 NSMutableSet 是无序对象集合。检查一个对象是否存在通常是一个 O(1) 的操作，使得比 NSArray 快很多。NSSet 只在被使用的哈希方法平衡的情况下能高效的工作；如果所有的对象都在同一个哈希筐内，NSSet 在查找对象是否存在时并不比 NSArray 快多少。

&emsp;NSSet 还有变体 NSCountedSet，以及非 toll-free 计数变体 CFBag / CFMutableBag。

&emsp;NSSet 会 retain 它其中的对象，但是根据 set 的规定，对象应该是不可变的。添加一个对象到 set 中随后改变它会导致一些奇怪的问题并破坏 set 的状态。

&emsp;NSSet 的方法比 NSArray 少的多。没有排序方法，但有一些方便的枚举方法。重要的方法有 allObjects，将对象转化为 NSArray，anyObject 则返回任意的对象，如果 set 为空，则返回 nil。

### 特点

1.  无序
2.  查找效率高O(1)
3.  添加的对象应该是不可变的
4.  ==不支持下标语法==


### 使用

#### NSSet
```
NSSet *set = [NSSet setWithObjects:@"www",@"2222",@"ssss",@"pppppp", nil];
    NSLog(@"%@",set);
    /*
        结果：
     {(
         www,
         ssss,
         2222,
         pppppp
     )}
      证明：无序
     */
```


#### NSSMutableSet

##### 交集:
```
  NSMutableSet *m1Set = [NSMutableSet setWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    NSMutableSet *m2Set = [NSMutableSet setWithObjects:@"4",@"5", nil];
    NSMutableSet *m3Set = [NSMutableSet setWithObjects:@"1",@"2",@"3",@"21", nil];
     //求两者的交集:
    [m2Set intersectSet:m1Set];
    NSLog(@"m2Set 和 m1Set 都有的元素是:%@",m2Set);
    /*
        结果：
     {(
         4,
         5
     )}
     */
     
  
     
     
```
##### 差集
```
   
      [m1Set minusSet:m2Set];

    NSLog(@"m1Set 减去m2Set 中的内容之后--%@",m1Set);

    /*
     结果：
     m1Set 减去m2Set 中的内容之后--{(
         3,
         1,
         2
     )}
     */
```
##### 并集


```
[m2Set unionSet:m3Set];
    
    NSLog(@"m2Set  和 m3Set 的并集是 --> %@",m2Set);
    
    /*
     m2Set  和 m3Set 的并集是 --> {(
         3,
         1,
         21,
         4,
         2,
         5
     )}
     */
```
## NSOrderedSet/NSMutableOrderedSet

### 定义

&emsp;NSOrderedSet 在 iOS 5 和 Mac OS X 10.7 中第一次被引入，除了 Core Data，几乎没有直接使用它的 API。看上去它综合了 NSArray 和 NSSet 两者的好处，对象查找，对象唯一性，和快速随机访问。

&emsp;NSOrderedSet 有着优秀的 API 方法，使得它可以很便利的与其他 set 或者有序 set 对象合作。==合并，交集，差集==，就像 NSSet 支持的那样。它有 NSArray 中除了比较陈旧的基于函数的排序方法和二分查找以外的大多数排序方法。毕竟 containsObject: 非常快，所以没有必要再用二分查找了。

&emsp;NSOrderedSet 的 array 和 set 方法分别返回一个 NSArray 和 NSSet，这些对象表面上是不可变的对象，但实际上在 NSOrderedSet 更新的时候，它们也会更新自己。如果你在不同线程上使用这些对象并发生了诡异异常的时候，知道这一点是非常有好处的。本质上，这些类使用的是 __NSOrderedSetSetProxy 和 __NSOrderedSetArrayProxy。

[NSOrderedSet 不是继承自NSSet](https://nshipster.cn/nsorderedset/)

### 特点

#### 优点

1. 查找效率高
2. 可以求并集，差集，交集 （NSMutableOrderedSet）
3. 有序的集合
4. 支持下标语法


#### 缺点
&emsp;NSOrderedSet 比 NSSet 和 NSArray 占用更多的内存，因为它需要同时维护哈希值和索引


### 使用


```
NSMutableOrderedSet *order1 = [NSMutableOrderedSet orderedSetWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    NSMutableOrderedSet *order2 = [NSMutableOrderedSet orderedSetWithObjects:@"4",@"5", nil];
    NSMutableOrderedSet *order3 = [NSMutableOrderedSet orderedSetWithObjects:@"1",@"2",@"3",@"4222", nil];
```


#### 交集


```

    
    // 交集
    
    [order1 intersectsSet:[order2 set]];
    NSLog(@"交集==%@",order1);
    
    /*
        结果：
     交集=={(
         1,
         2,
         3,
         4,
         5
     )}
     
     */
```
#### 差集


```
[order1 minusSet:[order2 set]];
    
    NSLog(@"差集==%@",order1);
    
    /* 结果
     差集=={(
         1,
         2,
         3
     )}
     */
```
#### 并集


```
// 并集
    [order2 unionSet:[order3 set]];
    
    NSLog(@"并集==%@",order2);
    
    /* 结果
     并集=={(
         4,
         5,
         1,
         2,
         3,
         4222
     )}
     */
```
#### 返回NSArray和NSSet



```
NSArray *arr = [order1 array];
    NSLog(@"arr:%@",arr);
    /*
     结果:
     arr:(
         1,
         2,
         3,
         4,
         5
     )
     */
    NSSet *set = [order1 set];
    NSLog(@"set:%@",set);
    /*
     结果:
     set:(
         1,
         2,
         3,
         4,
         5
     )
     */
```
#### 下标取值


```
NSString *idxValue = [order1 objectAtIndex:1];
    
    NSLog(@"idxValue = %@",idxValue);
    /*
     结果 ：
     
        idxValue = 2
     */
```


## NSPointerFunctions

&emsp;NSPointerFunctions这些指针函数可以被用在 NSHashTable，NSMapTable和 NSPointerArray 中，定义了对存储在这个集合中的对象的获取和保留行为。这里只介绍最有用的选项。完整列表参见 NSPointerFunctions.h。
 
 有两组选项。内存选项决定了内存管理，个性化定义了哈希和相等。
 
-  NSPointerFunctionsStrongMemory 创建了一个retain/release 对象的集合，非常像常规的 NSSet 或 NSArray。

- NSPointerFunctionsWeakMemory使用和__weak等价的方式来存储对象并自动移除被销毁的对象。

-  NSPointerFunctionsCopyIn 在对象被加入到集合前拷贝它们。
 
-  NSPointerFunctionsObjectPersonality 使用对象的 hash 和 isEqual: (默认)。
 
-  NSPointerFunctionsObjectPointerPersonality 对于 isEqual: 和 hash 使用直接的指针比较。



## NSHashTable 

### 定义
 &emsp;效仿了 NSSet，但在对象/内存处理时更加的灵活。可以通过自定义 CFSet 的回调获得 NSHashTable 的一些特性，哈希表可以保持对对象的弱引用并在对象被销毁之后正确的将其移除，有时候如果手动在 NSSet 中添加的话，想做到这个是挺恶心的一件事。它是默认可变的 — 并且这个类没有相应的不可变版本。
 
 
  &emsp; NSHashTable 可以通过 initWithPointerFunctions:capacity: 进行大量的设置 — 我们只选取使用预先定义的 hashTableWithOptions: 这一最普遍的使用场景。其中最有用的选项有利用 weakObjectsHashTable 来使用其自身的构造函数。
### NSHashTable 性能特征


```
类 / 时间 [ms]    1.000.000 elements
 NSHashTable, adding    2511.96
 NSMutableSet, adding    1423.26
 NSHashTable, random access    3.13
 NSMutableSet, random access    4.39
 NSHashTable, containsObject    6.56
 NSMutableSet, containsObject    6.77
 NSHashTable, NSFastEnumeration    39.03
 NSMutableSet, NSFastEnumeration    30.43
```

 &emsp;如果你只是需要 NSSet 的特性，请坚持使用 NSSet。NSHashTable 在添加对象时花费了将近2倍的时间，但是其他方面的效率却非常相近。
 
###   NSHashTable 与 NSSet / NSMutableSet 的比较

&emsp;NSHashTable 是 NSSet 的通用版本，和 NSSet / NSMutableSet 不同的是，NSHashTable 具有下面这些特性：
 
-  NSSet / NSMutableSet 持有成员的强引用，通过 hash 和 isEqual: 方法来检测成员的散列值和相等性。
-  NSHashTable 是可变的，没有不可变的对应版本。
-  NSHashTable 可以持有成员的弱引用。
-  NSHashTable 可以在加入成员时进行 copy 操作。
-  NSHashTable 可以存储任意的指针，通过指针来进行相等性和散列检查。
-  不是线程安全的


## NSMapTable 

&emsp;NSMapTable 和 NSHashTable 相似，但是效仿的是 NSDictionary。因此，我们可以通过 mapTableWithKeyOptions:valueOptions: 分别控制键和值的对象获取/保留行为。存储弱引用是 NSMapTable 最有用的特性，这里有4个方便的构造函数:


```
strongToStrongObjectsMapTable
weakToStrongObjectsMapTable
strongToWeakObjectsMapTable
weakToWeakObjectsMapTable
```

- [x] 注意，除了使用 NSPointerFunctionsCopyIn，任何的默认行为都会 retain (或弱引用)键对象而不会拷贝它，这与 CFDictionary 的行为相同而与 NSDictionary 不同。当你需要一个字典，它的键没有实现 NSCopying 协议的时候（比如像 UIView），这会非常有用。

&emsp;如果你好奇为什么苹果”忘记”为 NSMapTable 增加下标，你现在知道了。下标访问需要一个 id<NSCopying> 作为 key，对 NSMapTable 来说这不是强制的。如果不通过一个非法的 API 协议或者移除 NSCopying 协议来削弱全局下标，是没有办法给它增加下标的。

&emsp;你可以通过 dictionaryRepresentation 把内容转换为普通的 NSDictionary。不像 NSOrderedSet，这个方法返回的是一个常规的字典而不是一个代理。

### NSMapTable 性能特征

```
类 / 时间 [ms]	1.000.000 elements
NSMapTable, adding	2958.48
NSMutableDictionary, adding	2522.47
NSMapTable, random access	13.25
NSMutableDictionary, random access	9.18
```

&emsp;NSMapTable 只比 NSDictionary 略微慢一点。如果你需要一个不 retain 键的字典，放弃 CFDictionary 而使用它吧。




### NSMapTable && NSDictionary / NSMutableDictionary 的区别

&emsp;NSMapTable 是 NSDictionary 的通用版本。和 NSDictionary / NSMutableDictionary 不同的是，NSMapTable 具有下面这些特性：

#### (1) NSDictionary / NSMutableDictionary 对键进行拷贝，对值持有强引用。
&emsp; ==因为对键值进行拷贝，所以要求键必须遵守了NSCopying协议，如果此时你想用自定义的Model做键，那么必须要遵守NSCopying==

- [x]  注意 ++NSDictionary / NSMutableDictionary 对键的copy是深拷贝++
```
 NSMutableDictionary <id,NSMutableSet <Model*>*> *dic = [[NSMutableDictionary alloc] init];
 
 [dic setObject:<#(nonnull NSMutableSet<Model *> *)#> forKey:<#(nonnull id<NSCopying>)#>]

```


#### (2) NSMapTable 是可变的，没有不可变的对应版本。

&emsp; 

#### (3) NSMapTable 可以持有键和值的弱引用，当键或者值当中的一个被释放时，整个这一项就会被移除掉。

&emsp; 当键被释放时 再跟据 键在 maptable查找 则返回nil


```
NSMapTable <id,NSMutableSet<Model*>*>*map = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsObjectPersonality valueOptions:NSPointerFunctionsWeakMemory capacity:10];
    
//    NSMutableDictionary <id,NSMutableSet <Model*>*> *dic = [[NSMutableDictionary alloc] init];
    
    Model *m1 = [[Model alloc] init];
    
    NSMutableSet *set = [self models];
    
    [map setObject:set forKey:m1];
    
//    [dic setObject:<#(nonnull NSMutableSet<Model *> *)#> forKey:<#(nonnull id<NSCopying>)#>]
    
    Model *m2 = [[Model alloc] init];
    
    NSMutableSet *set2 = [self models];
    
    [map setObject:set2 forKey:m2];
    
    Model *m3 = [[Model alloc] init];
    
    NSMutableSet *set3 = [self models];
    
    [map setObject:set3 forKey:m3];
    
    NSLog(@" map: --> %@",map);
    
    NSLog(@"set nil befroe:%@",[map objectForKey:m3]);
    m3 = nil;
    NSLog(@"set nil after:%@",[map objectForKey:m3]);


结果：


map: --> NSMapTable {
[0] <Model: 0x600000634a80> -> {(
    <Model: 0x600000634900>,
    <Model: 0x600000634f60>
)}
[3] <Model: 0x600000633c80> -> {(
    <Model: 0x60000003eb20>,
    <Model: 0x600000635780>
)}
[5] <Model: 0x6000006344a0> -> {(
    <Model: 0x600000633d80>,
    <Model: 0x600000633a40>
)}
}
 set nil befroe:{(
    <Model: 0x600000634900>,
    <Model: 0x600000634f60>
)}
 set nil after:(null)


```


#### (4) NSMapTable 可以在加入成员时进行 copy 操作。
&emsp;  当初始化设置的参数 NSPointerFunctionsOptions 为NSPointerFunctionsCopyIn时，对成员进行拷贝，此时键必须遵循NSCopying协议 

```
NSMapTable <id,NSMutableSet<Model*>*>*map = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSPointerFunctionsWeakMemory capacity:10];
```


#### (5) NSMapTable 可以存储任意的指针，通过指针来进行相等性和散列检查。
&emsp; 
==注意:== NSMapTable 专注于强引用和弱引用，意外着 Swift 中流行的值类型是不适用的，只能用于引用类型。

#### (6)不是线程安全的



### 参考文档
 
[基础集合类](https://objccn.io/issue-7-1/)
