## 一、整体结构

![KVO](https://github.com/JiWuChao/OCKeyPoint/blob/master/AboutKVO/FBKVO%E6%BA%90%E7%A0%81%E8%A7%A3%E6%9E%90/KVOController.png?raw=true)

## 二、各类介绍

### _FBKVOInfo 

&emsp;私有的数据结构 _FBKVOInfo，这个类中包含着所有与 KVO 有关的信息。_FBKVOInfo 在 KVOController 中充当的作用仅仅是一个数据结构，我们主要用它来存储整个 KVO 过程中所需要的全部信息，其内部没有任何值得一看的代码，需要注意的是，_FBKVOInfo 覆写了 -isEqual: 方法用于对象之间的判等以及方便 NSMapTable 的存储



### NSObject+FBKVOController


```
@interface NSObject (FBKVOController)

 
@property (nonatomic, strong) FBKVOController *KVOController;

 
@property (nonatomic, strong) FBKVOController *KVOControllerNonRetaining;

@end
```

&emsp; 运用runtime 机制给NSObject 动态的添加两个属性  ==KVOController== 和 ==KVOControllerNonRetaining== 分别是强引用和弱引用。



### _FBKVOSharedController 

#### _FBKVOSharedController的作用

&emsp;是一个单利接受FBKVOController 转发给自己的有keypath等属性生成的FBKVOInfo 做一个统一的处理。
1. 把_FBKVOInfo存储在本地的 ==NSHashTable<_FBKVOInfo *> *_infos;==
2.  要把维护的哈希表中要监听的属性统一调用系统的
```
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context 
```
方法
3. 需要移除某个keyPath时 调用系统方法

```
- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context
```


#### _FBKVOSharedController对外方法


```
/** A shared instance that never deallocates. */
+ (instancetype)sharedController;

/**  添加一个观察者 */
- (void)observe:(id)object info:(nullable _FBKVOInfo *)info;

/** 移除一个观察者 */
- (void)unobserve:(id)object info:(nullable _FBKVOInfo *)info;

/** 移除一组观察者 */
- (void)unobserve:(id)object infos:(nullable NSSet *)infos;
```

#### 私有属性 


##### 第一个属性


```
// 存储 FBKVOInfo 的哈希表

NSHashTable<_FBKVOInfo *> *_infos;

```

##### 第二个属性

```
//线程锁
 pthread_mutex_t _mutex;

```


### FBKVOController

#### 对外API
```
/**
 @abstract   逐个添加kvo
 @param object  要监听的对象
 @param keyPath 要监听对象的keypath
 @param options 要监听的类型 new。old。initail 
 @param block  回调
 @discussion On key-value change, the specified block is called. In order to avoid retain loops, the block must avoid referencing the KVO controller or an owner thereof. Observing an already observed object key path or nil results in no operation.
 */
- (void)observe:(nullable id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(FBKVONotificationBlock)block;
```

```
/**
 @abstract 批量添加kvo
 @param object The object to observe.
 @param keyPaths The key paths to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param block The block to execute on notification.
 @discussion On key-value change, the specified block is called. Inorder to avoid retain loops, the block must avoid referencing the KVO controller or an owner thereof. Observing an already observed object key path or nil results in no operation.
 */
- (void)observe:(nullable id)object keyPaths:(NSArray<NSString *> *)keyPaths options:(NSKeyValueObservingOptions)options block:(FBKVONotificationBlock)block;
```


```
/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPath The key path to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param context The context specified.
 @discussion On key-value change, the observer's -observeValueForKeyPath:ofObject:change:context: method is called. Observing an already observed object key path or nil results in no operation.
 */
- (void)observe:(nullable id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;

- (void)observe:(nullable id)object keyPaths:(NSArray<NSString *> *)keyPaths options:(NSKeyValueObservingOptions)options context:(nullable void *)context;


```




```
/**
 @abstract Registers observer for key-value change notification.
 @param object The object to observe.
 @param keyPath The key path to observe.
 @param options The NSKeyValueObservingOptions to use for observation.
 @param action The observer selector called on key-value change.
 @discussion On key-value change, the observer's action selector is called. The selector provided should take the form of -propertyDidChange, -propertyDidChange: or -propertyDidChange:object:, where optional parameters delivered will be KVO change dictionary and object observed. Observing nil or observing an already observed object's key path results in no operation.
 */

- (void)observe:(nullable id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options action:(SEL)action;


- (void)observe:(nullable id)object keyPaths:(NSArray<NSString *> *)keyPaths options:(NSKeyValueObservingOptions)options action:(SEL)action;

```
#### 取消监听
```
/**
 @abstract Unobserve object key path.
 @param object The object to unobserve.
 @param keyPath The key path to observe.
 @discussion If not observing object key path, or unobserving nil, this method results in no operation.
 */
- (void)unobserve:(nullable id)object keyPath:(NSString *)keyPath;


```

```
/**
 @abstract Unobserve all object key paths.
 @param object The object to unobserve.
 @discussion If not observing object, or unobserving nil, this method results in no operation.
 */
- (void)unobserve:(nullable id)object;


```

```
/**
 @abstract Unobserve all objects.
 @discussion If not observing any objects, this method results in no operation.
 */
- (void)unobserveAll;
```





#### 私有属性

#### 第一个属性
```
/*
     key : object 即被观察的对象
     value : object 中被观察的属性所生成的FBKVOinfo
     NSMutableSet 是一个容器 表示一个key （object 被观察的对象）可能有多个value
*/
NSMapTable<id, NSMutableSet<_FBKVOInfo *> *> *_objectInfosMap; 
```


```
演示如下：
 
    self.father = [[Father alloc] init];
    self.son = [[Son alloc] init];
    
    [self.KVOController observe:self.father keyPath:@"name" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"father.name == %@",self.father.name);
    }];
    [self.KVOController observe:self.father keyPath:@"age" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"father.age == %ld",(long)self.father.age);
    }];
    [self.KVOController observe:self.father keyPath:@"address" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"father.address == %ld",(long)self.father.address);
    }];
    
    [self.KVOController observe:self.son keyPath:@"name" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"son.name == %@",self.son.name);
    }];
    [self.KVOController observe:self.son keyPath:@"age" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"son.age == %ld",(long)self.son.age);
    }];
    
    
    self.father.name = @"father-李四";
    self.father.age = 100;
    self.father.address = @"上海";
    
    self.son.name = @"小明";
    self.son.age = 21;
    
    
则 _objectInfosMap 的内容为 

_objectInfosMap -> = NSMapTable {
[0] <Father: 0x60000023fd00> -> {(
    <_FBKVOInfo: 0x600000676b40>,
    <_FBKVOInfo: 0x60400027f200>,
    <_FBKVOInfo: 0x600000475d40>
)}
[15] <Son: 0x60000023fd20> -> {(
    <_FBKVOInfo: 0x600000676b80>,
    <_FBKVOInfo: 0x60000046bcc0>
)}
}

如上可知 Object Father 对应着三个FBKVOInfo

Son对应着两个KVOInfo

```

#### 第二个属性

```
// 保证 FBKVOControllr 的线程安全
pthread_mutex_t _lock;
```


## 三、添加的KVO的过程


### 监听的过程

 

&emsp;kvoController 调用下面的方法 把要监听的Object 和 object的要监听的属性存储在一个表中 然后把object 转发到 _FBKVOSharedController 掉用相关的方法，在_FBKVOSharedController 中有一个哈希表把要监听的属性统一调用系统的
```
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context 
```
方法

#### 第一步：在kvoController 中根据传入的参数 生成一个info

```
- (void)observe:(nullable id)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options block:(FBKVONotificationBlock)block
{
  NSAssert(0 != keyPath.length && NULL != block, @"missing required parameters observe:%@ keyPath:%@ block:%p", object, keyPath, block);
  if (nil == object || 0 == keyPath.length || NULL == block) {
    return;
  }

  // 生成一个事件的info
  _FBKVOInfo *info = [[_FBKVOInfo alloc] initWithController:self keyPath:keyPath options:options block:block];

  //  把事件的info 添加到观察中去
  [self _observe:object info:info];
}

```
#### 第二步：根据生成的info和object 建立一个 key 为 被监听的对象（object），value 为存储被监听的对象的被监听的具体属性的一个mutableSet的 maptable

```
- (void)_observe:(id)object info:(_FBKVOInfo *)info
{
  // 加锁
  pthread_mutex_lock(&_lock);

 // 根据objec 取出 存放FBKVOInfo的表
 
  NSMutableSet *infos = [_objectInfosMap objectForKey:object];

  // 判断当前的有被监听的keypath 生成的info 是否存在 
  _FBKVOInfo *existingInfo = [infos member:info];
  if (nil != existingInfo) {
    //如果已经存在 则 把锁打开 返回
    pthread_mutex_unlock(&_lock);
    return;
  }

  // 如果当前的object 第一次添加 则生成object 对应的NSMutableSet 
  if (nil == infos) {
    infos = [NSMutableSet set];
    // 存放在mapTable中 key 是object value 是infos
    [_objectInfosMap setObject:infos forKey:object];
  }
 
  // 把对应的info 添加在对应的object 为key的表中
  [infos addObject:info];

  // 去除锁
  pthread_mutex_unlock(&_lock);
    
  // 调用 _FBKVOSharedController 的添加观察者方法
  [[_FBKVOSharedController sharedController] observe:object info:info];
}

```
#### 第三步：把要监听的object 和 info转发到_FBKVOSharedController，在_FBKVOSharedController 这个单利中 生成一个存储info的全局的哈希表，把相应的info存储进哈希表_info中

```
- (void)observe:(id)object info:(nullable _FBKVOInfo *)info
{
 // 如果info 为空 则不做处理
  if (nil == info) {
    return;
  }

  // 添加到哈希表中
  pthread_mutex_lock(&_mutex);
  [_infos addObject:info];
  pthread_mutex_unlock(&_mutex);

  // 添加注册
  [object addObserver:self forKeyPath:info->_keyPath options:info->_options context:(void *)info];
  //改变info的状态
  if (info->_state == _FBKVOInfoStateInitial) {
    info->_state = _FBKVOInfoStateObserving;
  } else if (info->_state == _FBKVOInfoStateNotObserving) {
    //删除
    [object removeObserver:self forKeyPath:info->_keyPath context:(void *)info];
  }
}

```

### 被监听的属性发生变化时的处理

- 第一步：根据context 取出info
- 第二步: 如果info不为空，根据info取出controller - FBKVOController
- 第三步：如果controller 不为空，根据controller 取出observer
- 第四步：如果observer不为空，且info不为空，根据info 取出block
- 第五步：如果block不为空，组织change
- 第六步：返回block
- 第七步：在第五步中如果block为空，判断info的action是否为空，如果不为空则执行action
- 第八步：如果在第七步中判断action 也为空 则执行observer 的
```
-(void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(nullable void *)context
```
 方法



```
- (void)observeValueForKeyPath:(nullable NSString *)keyPath
                      ofObject:(nullable id)object
                        change:(nullable NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(nullable void *)context
{
  NSAssert(context, @"missing context keyPath:%@ object:%@ change:%@", keyPath, object, change);

  _FBKVOInfo *info;

  {
    //  根据 context 取出info
    pthread_mutex_lock(&_mutex);
    info = [_infos member:(__bridge id)context];
    pthread_mutex_unlock(&_mutex);
  }

  if (nil != info) {//info 存在

    // take strong reference to controller
    FBKVOController *controller = info->_controller;
    if (nil != controller) {

      // take strong reference to observer
      id observer = controller.observer;
      if (nil != observer) {

        // dispatch custom block or action, fall back to default action
        if (info->_block) {
          NSDictionary<NSKeyValueChangeKey, id> *changeWithKeyPath = change;
          // add the keyPath to the change dictionary for clarity when mulitple keyPaths are being observed
          if (keyPath) {
            NSMutableDictionary<NSString *, id> *mChange = [NSMutableDictionary dictionaryWithObject:keyPath forKey:FBKVONotificationKeyPathKey];
            [mChange addEntriesFromDictionary:change];
            changeWithKeyPath = [mChange copy];
          }
          //block
          info->_block(observer, object, changeWithKeyPath);
        } else if (info->_action) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        // action
          [observer performSelector:info->_action withObject:change withObject:object];
#pragma clang diagnostic pop
        } else {
          [observer observeValueForKeyPath:keyPath ofObject:object change:change context:info->_context];
        }
      }
    }
  }
}

```





## 四、取消监听的过程

### 在FBKVOController 中

### 第一种情况 删除某一个被监听对象（object）的某一个 keypath

#### 第一步 先根据keypath 生成相应的info

```
- (void)unobserve:(nullable id)object keyPath:(NSString *)keyPath
{
  // 根据keyPath 生成info
  _FBKVOInfo *info = [[_FBKVOInfo alloc] initWithController:self keyPath:keyPath];

  // unobserve object property
  [self _unobserve:object info:info];
}


```
#### 第二步  取出相应的object 中的infos 然后在infos 中查询是否有目标info 如果有则在infos中删除

```
- (void)_unobserve:(id)object info:(_FBKVOInfo *)info
{
  // lock
  pthread_mutex_lock(&_lock);

  // get observation infos
  NSMutableSet *infos = [_objectInfosMap objectForKey:object];

  // lookup registered info instance
  _FBKVOInfo *registeredInfo = [infos member:info];

  if (nil != registeredInfo) {
    [infos removeObject:registeredInfo];

    // 判端当前infos是否有值 如果没有值 则删除key为object的相关数据
    if (0 == infos.count) {
      [_objectInfosMap removeObjectForKey:object];
    }
  }

  // unlock
  pthread_mutex_unlock(&_lock);

  // unobserve
  [[_FBKVOSharedController sharedController] unobserve:object info:registeredInfo];
}
```
#### 第三步 转发到_FBKVOSharedController，在_FBKVOSharedController 中的哈希表中删除 对应的info


```
- (void)unobserve:(id)object info:(nullable _FBKVOInfo *)info
{
  if (nil == info) {
    return;
  }

  // unregister info
  pthread_mutex_lock(&_mutex);
  [_infos removeObject:info];
  pthread_mutex_unlock(&_mutex);

  // remove observer
  if (info->_state == _FBKVOInfoStateObserving) {
    [object removeObserver:self forKeyPath:info->_keyPath context:(void *)info];
  }
  info->_state = _FBKVOInfoStateNotObserving;
}

```


### 第二种情况 移除整个被监听者
 
```
- (void)unobserve:(nullable id)object
{
  if (nil == object) {
    return;
  }

  [self _unobserve:object];
}

```


#### 第一步：根据被监听者，取出与其相关的所有keypath的infos，然后在 maptable 表中删除 key为object的值，然后把infos 传入_FBKVOSharedController

```
- (void)_unobserve:(id)object
{
  // 加锁
  pthread_mutex_lock(&_lock);
 
  //根据object 取出  存储infos的 NSMutableSet
  NSMutableSet *infos = [_objectInfosMap objectForKey:object];

  // 把观察的对象从 maptable中删除
  [_objectInfosMap removeObjectForKey:object];

  // unlock
  pthread_mutex_unlock(&_lock);

  // 把根据 object 取出的 存储infos的 NSMutableSet 的传给 _FBKVOSharedController
  [[_FBKVOSharedController sharedController] unobserve:object infos:infos];
}

```
#### 第二步 转发到 _FBKVOSharedController 中

```
- (void)unobserve:(id)object infos:(nullable NSSet<_FBKVOInfo *> *)infos
{
 // 首先判断infos 是否为空 ，如果为空则不做处理
  if (0 == infos.count) {
    return;
  }

  // 如果不为空 则遍历infos 从_FBKVOSharedController中的哈希表infos 删除其遍历值
  
  pthread_mutex_lock(&_mutex);
  for (_FBKVOInfo *info in infos) {
    [_infos removeObject:info];
  }
  pthread_mutex_unlock(&_mutex);

  //  然后在遍历 传入的infos 逐个移除
  for (_FBKVOInfo *info in infos) {
    if (info->_state == _FBKVOInfoStateObserving) {
      [object removeObserver:self forKeyPath:info->_keyPath context:(void *)info];
    }
    info->_state = _FBKVOInfoStateNotObserving;
  }
}
```
## 五、自动取消监听

&emsp;在 FBKVOController中的dealloc 中自动释放全部监听

```
- (void)dealloc
{
  [self unobserveAll];
  pthread_mutex_destroy(&_lock);
}

```
## 六、循环引用的产生和解决

### 第一种

```
[self.KVOController observe:_son2 keyPath:@"age" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"self.son2.age == %ld",(long)self.son2.age);//会导致强引用
    }];
```
#### 原因
&emsp; self 强引用持有 KVOController ，KVOController 又强引用持有block ，上面的这种写法又导致 block强引用持有self。所以self 和 KVOController 形成循环引用都无法释放，导致无法移除监听。
#### 解决方法

&emsp; self 用weak 修饰，block 弱引用持有self 打破循环引用

```
    __weak typeof(self) weakself = self; 
    [self.KVOController observe:_son2 keyPath:@"age" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"self.son2.age == %ld",(long)weakself.son2.age); //
    }];
```
### 第二种


```
  [self.KVOController observe:self keyPath:@"textString" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"self.textString == %@",(long)weakself.textString);
    }];
    
```
#### 原因

&emsp; self 持有 KVOController 而 ‘self.KVOController observe:self keyPath:@"textString" ’ 导致 KVOController 持有self，形成循环引用


#### 解决方法

&emsp; self.KVOController 换成 self.KVOControllerNonRetaining
        KVOControllerNonRetaining 对self 是弱引用

```
[self.KVOControllerNonRetaining observe:self keyPath:@"textString" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"self.textString == %@",(long)weakself.textString);
    }];
```


## 第七、FBKVOController 和  _FBKVOSharedController 的分工
 
### 分工

&emsp; FBKVOController 负责外层，事件的管理，维护者一个存储着所有被观察者对象为key，以及被观察对象的所有被观察的属性为value的表。当具体的的添加监听和移除监听时是有_FBKVOSharedController 来做。

### 好处是什么？

&emsp;  目前的理解就是分层管理，是代码逻辑更清晰，有利于管理
