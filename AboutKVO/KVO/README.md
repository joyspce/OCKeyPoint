
## 简介

>KVO 是 Objective-C 对观察者模式（Observer Pattern）的实现。也是 Cocoa Binding 的基础。当被观察对象的某个属性发生更改时，观察者对象会获得通知。

## 方法说明


```
/**
 调用此方法者 self.fa 是要被监听的对象

 @param observer 观察者，负责处理监听事件的对象
 @param keyPath 要监听的属性
 @param options 观察的选项 (观察新，旧，原始值 也可以都观察)
 @param context 上下文 用于传递数据，可以利用上下文区分不同的监听
 */
 
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;


```


```
/**
 当监控的某个属性的值改变了就会调用

 @param keyPath 监听的属性名
 @param object 属性所属的对象
 @param change 属性的修改情况（属性原来的值`oldValue`、属性最新的值`newValue`）
 @param context 传递的上下文数据，与监听的时候传递的一致，可以利用上下文区分不同的监听
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"father.name = %@",self.fa.name);
}
```
## KVO内部实现原理

- KVO是基于runtime机制实现的
- 当某个类的属性对象第一次被观察时，系统就会在运行期动态地创建该类的一个派生类，在这个派生类中重写基类中任何被观察属性的setter 方法。派生类在被重写的setter方法内实现真正的通知机制
- 如果原类为Person，那么生成的派生类名为NSKVONotifying_Person
每个类对象中都有一个isa指针指向当前类，当一个类对象的第一次被观察，那么系统会偷偷将isa指针指向动态生成的派生类，从而在给被监控属性赋值时执行的是派生类的setter方法
- 键值观察通知依赖于NSObject 的两个方法: willChangeValueForKey: 和 didChangevlueForKey:；在一个被观察属性发生改变之前， willChangeValueForKey:一定会被调用，这就 会记录旧的值。而当改变发生后，didChangeValueForKey:会被调用，继而 observeValueForKey:ofObject:change:context: 也会被调用。
- 补充：KVO的这套实现机制中苹果还偷偷重写了class方法，让我们误认为还是使用的当前类，从而达到隐藏生成的派生类

 
![图片来源自简书](https://upload-images.jianshu.io/upload_images/1429890-b28e010d3a7dbdb8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/700)


## 手动触发KVO

&emsp;属性 “==fa==” 正常情况下 ，只要调用addObserver 方法之后，给fa赋值就能监听到。根据上面的KVO原理，手动调用

**willChangeValueForKey** 和  **didChangeValueForKey** 方法也是可以的


```

 [self addObserver:self forKeyPath:@"fa" options:NSKeyValueObservingOptionNew context:NULL];
    
    [self willChangeValueForKey:@"fa"];
    
    [self didChangeValueForKey:@"fa"];
```
&emsp;手动调用 **willChangeValueForKey** 和  **didChangeValueForKey** 方法之后 会触发下面的方法 
```
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"father.name = %@",self.fa.name);
}

```

## KVO 做了哪些事

### 例子
```
    NSLog(@"before: --isa--%@",[self.fa valueForKey:@"isa"]);
    NSLog(@"before: --class--%@",[self.fa class]);
    [self.fa addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];
    self.fa.name = @"张三";
    
    NSLog(@"after: --isa--%@",[self.fa valueForKey:@"isa"]);
    NSLog(@"after: --class--%@",[self.fa class]);
    
    
    /*
     输出结果:
     before: --isa--Father
     before: --class--Father
     father.name = 张三
     after: --isa--NSKVONotifying_Father
     after: --class--Father
     
     
     after: --isa--NSKVONotifying_Father 添加观察者之后
     iso 由值Father 被改为NSKVONotifying_Father
    
    
```

### 事实

```
1 重写被观察对象属性对应的setter
2 改变被观察对象的真实类型，且与原类为继承关系
3 重写被观察对象的- (Class)class

```






## 手动实现KVO

在addObserver方法里我们需要做什么呢?


```
1 检查对象是否存在该属性的setter方法, 没有的话我们就做什么都白搭了, 
既然别人都不允许你修改值了, 那也就不存在监听值改变的事了

2 检查自己(self)是不是一个kvo_class(如果该对象不是第一次
被监听属性, 那么它就是kvo_class, 反之则是原class), 如果是, 则跳过这一步; 
如果不是, 则要修改self的类(origin_class -> kvo_class)

3 经过第二步, 到了这里已经100%确定self是kvo_class的对象了,
那么我们现在就要重写kvo_class对象的对应属性的setter方法

4 最后, 将观察者对象(observer), 监听的属性(key), 
值改变时的回调block(callback),用一个模型(ObserverInfo)存
进来, 然后利用关联对象维护self的一个数组
(NSMutableArray<ObserverInfo *> *)

```




## 参考
  
  [1 简书:探究KVO的底层实现原理](https://www.jianshu.com/p/829864680648)
  
  [2 自己手动实现KVO](http://tech.glowing.com/cn/implement-kvo/)
  
  [3 简书:iOS-手动实现KVO](https://www.jianshu.com/p/bf053a28accb)