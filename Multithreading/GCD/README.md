[TOC]

## 1. GCD 简介
### 1.1 什么是 GCD 呢？

>Grand Central Dispatch(GCD) 是 Apple 开发的一个多核编程的较新的解决方法。它主要用于优化应用程序以支持多核处理器以及其他对称多处理系统。它是一个在线程池模式的基础上执行的并发任务。在 Mac OS X 10.6 雪豹中首次推出，也可在 iOS 4 及以上版本使用。

### 1.2 为什么要用 GCD 呢？

- GCD 可用于多核的并行运算
- GCD 会自动利用更多的 CPU 内核（比如双核、四核）
- GCD 会自动管理线程的生命周期（创建线程、调度任务、销毁线程）
- 程序员只需要告诉 GCD 想要执行什么任务，不需要编写任何线程管理代码

## 2. GCD 任务和队列
>**任务**：就是执行操作的意思，换句话说就是你在线程中执行的那段代码。在 GCD 中是放在 block 中的。执行任务有两种方式：同步执行（sync）和异步执行（async）。两者的主要区别是：是否等待队列的任务执行结束，以及是否具备开启新线程的能力。

### 同步执行（sync）：

1. 同步添加任务到指定的队列中，在添加的任务执行结束之前，会一直等待，直到队列里面的任务完成之后再继续执行。
2. 只能在当前线程中执行任务，不具备开启新线程的能力。

### 异步执行（async）：

1. 异步添加任务到指定的队列中，它不会做任何等待，可以继续执行任务。
2. 可以在新的线程中执行任务，具备开启新线程的能力。

- [x] 注意：==异步执行（async）虽然具有开启新线程的能力，但是并不一定开启新线程。这跟任务所指定的队列类型有关（下面会讲）==。

>**队列**（Dispatch Queue）：这里的队列指执行任务的等待队列，即用来存放任务的队列。队列是一种特殊的线性表，采用 FIFO（先进先出）的原则，即新任务总是被插入到队列的末尾，而读取任务的时候总是从队列的头部开始读取。每读取一个任务，则从队列中释放一个任务。


&emsp;在 GCD 中有两种队列：串行队列和并发队列。两者都符合 FIFO（先进先出）的原则。两者的主要区别是：执行顺序不同，以及开启线程数不同。

### 串行队列（Serial Dispatch Queue）：
1. 每次只有一个任务被执行。让任务一个接着一个地执行。一个任务执行完毕后，再执行下一个任务。
2. 只开启一个新线程（或者不开启新线程，在当前线程执行任务）。

### 并发队列（Concurrent Dispatch Queue）：
1. 可以让多个任务并发（同时）执行。
2. 可以开启多个线程，并且同时执行任务。


- [x] 注意：并发队列的并发功能只有在异步（dispatch_async）函数下才有效。


## 3. GCD 的使用步骤

### 3.1 队列的创建方法/获取方法

>可以使用dispatch_queue_create来创建队列，需要传入两个参数，第一个参数表示队列的唯一标识符，用于 DEBUG，可为空，Dispatch Queue 的名称推荐使用应用程序 ID 这种逆序全程域名；第二个参数用来识别是串行队列还是并发队列。DISPATCH_QUEUE_SERIAL 表示串行队列，DISPATCH_QUEUE_CONCURRENT 表示并发队列。

- [x]  注意：dispatch_queue_create 生成队列 无论是并发队列还是串行队列 其都是默认优先级


### 3.1.1 创建并发队列


```
// 并发
    dispatch_queue_t customQueue = dispatch_queue_create("com.jiwuchao.GCD_Queue", DISPATCH_QUEUE_CONCURRENT);
```
### 3.1.2 创建串行队列


```
// 串行队列
    dispatch_queue_t customSerial = dispatch_queue_create("com.jiwuchao.gcd_queue.serial", DISPATCH_QUEUE_SERIAL);
```
### 3.2 获取队列 

#### 主队列

>对于串行队列，GCD 提供了的一种特殊的串行队列：主队列（Main Dispatch Queue）。

1. 所有放在主队列中的任务，都会放到主线程中执行。
2. 可使用dispatch_get_main_queue()获得主队列。

&emsp;**主队列**：GCD自带的一种特殊的串行队列
所有放在主队列中的任务，都会放到主线程中执行
可使用 ==dispatch_get_main_queue()== 获得主队列

```
 //主队列
    dispatch_queue_t mainDispathQueue = dispatch_get_main_queue();`
```

>对于并发队列，GCD 默认提供了全局并发队列（Global Dispatch Queue）。
可以使用dispatch_get_global_queue来获取。需要传入两个参数。第一个参数表示队列优先级，一般用DISPATCH_QUEUE_PRIORITY_DEFAULT。第二个参数暂时没用，用0即可。
#### 全局队列

##### 高优先级
```
 //高优先级
    dispatch_queue_t globlehighQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
```
##### 默认优先级
```
//默认优先级
    dispatch_queue_t globleDefaultQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
```
##### 低优先级
```
//低优先级
    dispatch_queue_t globleLowQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
```

##### 后台
```
    dispatch_queue_t globleBackgtoundQueue2 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);

```

### 3.3 任务创建

#### 同步执行任务创建方法
```
// 串行队列 同步执行 不会新建线程
- (void)createTaskSys {
    
    // 串行队列
    dispatch_queue_t customSerial = dispatch_queue_create("com.jiwuchao.gcd_queue.serial", DISPATCH_QUEUE_SERIAL);
    
    
    dispatch_sync(customSerial, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@"1 current  thread %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(customSerial, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@"2 current  thread %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(customSerial, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@"3 current  thread %@",[NSThread currentThread]);
        }
    });
}

```
 异步执行任务创建方法 
```
- (void)createTaskAsy {
    // 并发队列
    dispatch_queue_t customQueue = dispatch_queue_create("com.jiwuchao.GCD_Queue", DISPATCH_QUEUE_CONCURRENT);
 
    dispatch_async(customQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@"1 current  thread %@",[NSThread currentThread]);
        }
    });
    dispatch_async(customQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@"2 current  thread %@",[NSThread currentThread]);
        }
    });
    
    dispatch_async(customQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@"3 current  thread %@",[NSThread currentThread]);
        }
    });
    dispatch_async(customQueue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@"4 current  thread %@",[NSThread currentThread]);
        }
    });

}

```
### 3.4 GCD 创建和使用队列总结

>虽然使用 GCD 只需两步，但是既然我们有两种队列（串行队列/并发队列），两种任务执行方式（同步执行/异步执行），那么我们就有了四种不同的组合方式。这四种不同的组合方式是：


1. 同步执行 + 并发队列
2. 异步执行 + 并发队列
3. 同步执行 + 串行队列
4. 异步执行 + 串行队列

&emsp;实际上，刚才还说了两种特殊队列：全局并发队列、主队列。全局并发队列可以作为普通并发队列来使用。但是主队列因为有点特殊，所以我们就又多了两种组合方式。这样就有六种不同的组合方式了

1. 同步执行 + 主队列
2. 异步执行 + 主队列

&emsp;那么这几种不同组合方式各有什么区别呢，这里为了方便，先上结果，再来讲解。你可以直接查看表格结果


区别 | 并发队列 | 串行队列 | 主队列 | 
---|---|---|---|---
同步(sync) | 没有开启新线程，串行执行任务|没有开启新线程，串行执行任务|主线程调用：死锁卡住不执行其他线程调用：没有开启新线程，串行执行任务 |
异步(async) | 有开启新线程，并发执行任务 |有开启新线程(1条)，串行执行任务 |没有开启新线程，串行执行任务|


## 4. GCD 的基本使用（6种不同组合区别）

### 4.1 同步执行 + 并发队列


```
/*
 同步执行 + 并发队列
 在当前线程中执行任务，不会开启新线程，执行完一个任务，再执行下一个任务
 */
- (void)gcduse1 {
    
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncConcurrent---begin");
    
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.gcduse", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1 - %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2 - %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3 - %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"4 - %@",[NSThread currentThread]);
        }
    });
    NSLog(@"syncConcurrent---end");
}


打印：

currentThread---<NSThread: 0x6000026c1780>{number = 1, name = main}
syncConcurrent---begin
1 - <NSThread: 0x6000026c1780>{number = 1, name = main}
1 - <NSThread: 0x6000026c1780>{number = 1, name = main}
2 - <NSThread: 0x6000026c1780>{number = 1, name = main}
2 - <NSThread: 0x6000026c1780>{number = 1, name = main}
3 - <NSThread: 0x6000026c1780>{number = 1, name = main}
3 - <NSThread: 0x6000026c1780>{number = 1, name = main}
4 - <NSThread: 0x6000026c1780>{number = 1, name = main}
4 - <NSThread: 0x6000026c1780>{number = 1, name = main}
syncConcurrent---end
 
```
**结论**：


1. 所有任务都是在当前线程（主线程）中执行的，没有开启新的线程（同步执行不具备开启新线程的能力）。
2. 所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间执行的（同步任务需要等待队列的任务执行结束）。
3. 任务按顺序执行的。按顺序执行的原因：虽然并发队列可以开启多个线程，并且同时执行多个任务。但是因为本身不能创建新线程，只有当前线程这一个线程（同步任务不具备开启新线程的能力），所以也就不存在并发。而且当前线程只有等待当前队列中正在执行的任务执行完毕之后，才能继续接着执行下面的操作（同步任务需要等待队列的任务执行结束）。所以任务只能一个接一个按顺序执行，不能同时被执行。


### 4.2 异步执行 + 并发队列


```
/*
  异步执行 + 并发队列
  可以开启多个线程，任务交替（同时）执行。
  */
- (void)gcduse2 {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncConcurrent---begin");
    
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.gcduse", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"4 - %@",[NSThread currentThread]);
        }
    });
    NSLog(@"asyncConcurrent---end");

}

打印：

currentThread---<NSThread: 0x6000011c1340>{number = 1, name = main}
asyncConcurrent---begin
asyncConcurrent---end
2 - <NSThread: 0x6000011955c0>{number = 3, name = (null)}
3 - <NSThread: 0x6000011aa900>{number = 4, name = (null)}
1 - <NSThread: 0x60000115dc40>{number = 5, name = (null)}
4 - <NSThread: 0x600001162a80>{number = 9, name = (null)}
3 - <NSThread: 0x6000011aa900>{number = 4, name = (null)}
1 - <NSThread: 0x60000115dc40>{number = 5, name = (null)}
4 - <NSThread: 0x600001162a80>{number = 9, name = (null)}
2 - <NSThread: 0x6000011955c0>{number = 3, name = (null)}



```

结论：

1. 除了当前线程（主线程），系统又开启了4个线程，并且任务是交替/同时执行的。（异步执行具备开启新线程的能力。且并发队列可开启多个线程，同时执行多个任务）。
2. 所有任务是在打印的asyncConcurrent---begin和asyncConcurrent---end之后才执行的。说明当前线程没有等待，而是直接开启了新线程，在新线程中执行任务（异步执行不做等待，可以继续执行任务）。




### 4.3 同步执行 + 串行队列

&emsp;不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务


```
/*
 同步执行 + 串行队列
 特点：不会开启新线程，在当前线程执行任务。任务是串行的，执行完一个任务，再执行下一个任务。
 */
- (void)gcduse3 {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"syncConcurrent---begin");
    
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.gcduse", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1 - %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2 - %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3 - %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"4 - %@",[NSThread currentThread]);
        }
    });
    NSLog(@"syncConcurrent---end");

    
}

打印：

currentThread---<NSThread: 0x600002639340>{number = 1, name = m
syncConcurrent---begin
1 - <NSThread: 0x600002639340>{number = 1, name = main}
1 - <NSThread: 0x600002639340>{number = 1, name = main}
2 - <NSThread: 0x600002639340>{number = 1, name = main}
2 - <NSThread: 0x600002639340>{number = 1, name = main}
3 - <NSThread: 0x600002639340>{number = 1, name = main}
3 - <NSThread: 0x600002639340>{number = 1, name = main}
4 - <NSThread: 0x600002639340>{number = 1, name = main}
4 - <NSThread: 0x600002639340>{number = 1, name = main}
syncConcurrent---end

```

**结论**：

1. 所有任务都是在当前线程（主线程）中执行的，并没有开启新的线程（同步执行不具备开启新线程的能力）。
2. 所有任务都在打印的syncConcurrent---begin和syncConcurrent---end之间执行（同步任务需要等待队列的任务执行结束）。
3. 任务是按顺序执行的（串行队列每次只有一个任务被执行，任务一个接一个按顺序执行）。

### 4.4 异步执行 + 串行队列
&emsp;会开启新线程，但是因为任务是串行的，执行完一个任务，再执行下一个任务

```
/*
 异步执行 + 串行队列
 */
- (void)gcduse4 {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"asyncConcurrent---begin");
    
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.gcduse", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"4 - %@",[NSThread currentThread]);
        }
    });
    NSLog(@"asyncConcurrent---end");

}

打印：

currentThread---<NSThread: 0x60000342ee40>{number = 1, name = main}
asyncConcurrent---begin
asyncConcurrent---end
1 - <NSThread: 0x6000012c8700>{number = 3, name = (null)}
1 - <NSThread: 0x6000012c8700>{number = 3, name = (null)}
2 - <NSThread: 0x6000012c8700>{number = 3, name = (null)}
2 - <NSThread: 0x6000012c8700>{number = 3, name = (null)}
3 - <NSThread: 0x6000012c8700>{number = 3, name = (null)}
3 - <NSThread: 0x6000012c8700>{number = 3, name = (null)}
4 - <NSThread: 0x6000012c8700>{number = 3, name = (null)}
4 - <NSThread: 0x6000012c8700>{number = 3, name = (null)}

```
结论：

1. 开启了一条新线程（异步执行具备开启新线程的能力，串行队列只开启一个线程）。
2. 所有任务是在打印的syncConcurrent---begin和syncConcurrent---end之后才开始执行的（异步执行不会做任何等待，可以继续执行任务）。
3. 任务是按顺序执行的（串行队列每次只有一个任务被执行，任务一个接一个按顺序执行）。


### 4.5 同步执行 + 主队列

&emsp; ==同步执行 + 主队列== 在不同线程中调用结果也是不一样，在主线程中调用会出现死锁，而在其他线程中则不会。


#### 4.5.1 在主线程中调用同步执行 + 主队列

&emsp;互相等待卡住不可行


```
/*
  同步执行 + 主队列
 */

- (void)gcduse5 {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"run---begin");
    
    // 获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1 - %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2 - %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3 - %@",[NSThread currentThread]);
        }
    });
    dispatch_sync(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"4 - %@",[NSThread currentThread]);
        }
    });
    NSLog(@"run---end");

}

打印：

currentThread---<NSThread: 0x600000eca900>{number = 1, name = main}
run---begin
(lldb) 


```
结论：

>在主线程中使用同步执行 + 主队列，追加到主线程的任务1、任务2、任务3都不再执行了，而且run---end也没有打印,还会出现崩溃？

&emsp;这是因为我们在主线程中执行gcduse5 方法，相当于把gcduse5 任务放到了主线程的队列中。而同步执行会等待当前队列中的任务执行完毕，才会接着执行。那么当我们把任务1追加到主队列中，任务1就在等待主线程处理完gcduse5 任务。而gcduse5任务需要等待任务1执行完毕，才能接着执行。

那么，现在的情况就是gcduse5 任务和任务1都在等对方执行完毕。这样大家互相等待，所以就卡住了，所以我们的任务执行不了，而且run---end也没有打印

>要是如果不在主线程中调用，而在其他线程中调用会如何呢？

#### 4.5.2 在其他线程中调用同步执行 + 主队列

&emsp;不会开启新线程，执行完一个任务，再执行下一个任务


```
//5.1 在其他线程 ： 同步执行 + 主队列

[NSThread detachNewThreadSelector:@selector(gcduse5) toTarget:self withObject:nil];


打印：

currentThread---<NSThread: 0x600001a3c500>{number = 3, name = (null)}

run---begin
1 - <NSThread: 0x600001a5f700>{number = 1, name = main}
1 - <NSThread: 0x600001a5f700>{number = 1, name = main}
2 - <NSThread: 0x600001a5f700>{number = 1, name = main}
2 - <NSThread: 0x600001a5f700>{number = 1, name = main}
3 - <NSThread: 0x600001a5f700>{number = 1, name = main}
3 - <NSThread: 0x600001a5f700>{number = 1, name = main}
4 - <NSThread: 0x600001a5f700>{number = 1, name = main}
4 - <NSThread: 0x600001a5f700>{number = 1, name = main}
run---end
```
结论：
- 所有任务都是在主线程（非当前线程）中执行的，没有开启新的线程（所有放在主队列中的任务，都会放到主线程中执行）。
- 所有任务都在打印的run---begin和run---end之间执行（同步任务需要等待队列的任务执行结束）。
- 任务是按顺序执行的（主队列是串行队列，每次只有一个任务被执行，任务一个接一个按顺序执行）。

### 4.6 异步执行 + 主队列

&emsp;只在主线程中执行任务，执行完一个任务，再执行下一个任务。


```
/*
  异步执行 + 主队列
 */
- (void)gcduse6 {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"run---begin");
    
    // 获取主队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"4 - %@",[NSThread currentThread]);
        }
    });
    NSLog(@"run---end");

}

打印：

currentThread---<NSThread: 0x6000036e3840>{number = 1, name = main}
run---begin
run---end
1 - <NSThread: 0x6000036e3840>{number = 1, name = main}
1 - <NSThread: 0x6000036e3840>{number = 1, name = main}
2 - <NSThread: 0x6000036e3840>{number = 1, name = main}
2 - <NSThread: 0x6000036e3840>{number = 1, name = main}
3 - <NSThread: 0x6000036e3840>{number = 1, name = main}
3 - <NSThread: 0x6000036e3840>{number = 1, name = main}
4 - <NSThread: 0x6000036e3840>{number = 1, name = main}
4 - <NSThread: 0x6000036e3840>{number = 1, name = main}


```

结论：

- 所有任务都是在当前线程（主线程）中执行的，并没有开启新的线程（虽然异步执行具备开启线程的能力，但因为是主队列，所以所有任务都在主线程中）。
- 所有任务是在打印的syncConcurrent—begin和syncConcurrent—end之后才开始执行的（异步执行不会做任何等待，可以继续执行任务）。
- 任务是按顺序执行的（因为主队列是串行队列，每次只有一个任务被执行，任务一个接一个按顺序执行）。



## 5. GCD 线程间的通信



```

- (void)gcduse7 {
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.oo", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i ++ ) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"thread -- %@",[NSThread currentThread]);
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"main thread -- %@",[NSThread currentThread]);
            NSLog(@"回到了主线程");
            
        });
        
        
    });
    
}


打印：

thread -- <NSThread: 0x600003db6940>{number = 3, name = (null)}
thread -- <NSThread: 0x600003db6940>{number = 3, name = (null)}
main thread -- <NSThread: 0x600003dee940>{number = 1, name = main}
回到了主线程


```
**结论**：

&emsp;可以看到在其他线程中先执行任务，执行完了之后回到主线程执行主线程的相应操作

## 6 Dispatch_set_target_queue 

### 6.1 设置优先级

&emsp; dispatch_queue_create函数生成的Dispatch Queue不管是Serial Dispatch Queue还是Concurrent Dispatch Queue,执行的优先级都与默认优先级的Global Dispatch queue相同,如果需要变更生成的Dispatch Queue的执行优先级则需要使用dispatch_set_target_queue函数

```
- (void)setPriority {
    // 默认优先级
    
    dispatch_queue_t serialQueue = dispatch_queue_create("com.jiwuchao.www.set", DISPATCH_QUEUE_SERIAL);
    // 获取全局队列 优先级为高
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH,0);
    // 把serialQueue 的优先级 设置为和 globalQueue 一样
    
    // 第一个参数为要设置优先级的queue,第二个参数是参照物，既将第一个queue的优先级和第二个queue的优先级设置一样
    dispatch_set_target_queue(serialQueue, globalQueue);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        NSLog(@"我的优先级是 DISPATCH_QUEUE_PRIORITY_LOW");
    });
    
    dispatch_async(serialQueue, ^{
        NSLog(@"我的优先级是 DISPATCH_QUEUE_PRIORITY_HIGH");
    });
    
}

打印：


 我的优先级是 DISPATCH_QUEUE_PRIORITY_HIGH
 我的优先级是 DISPATCH_QUEUE_PRIORITY_LOW


```
 
### 6.2 队列执行

>dispatch_set_target_queue除了能用来设置队列的优先级之外，还能够创建队列的层次体系，当我们想让不同队列中的任务并发的执行时，我们可以创建一个串行队列，然后将这些队列的target指向新创建的队列即可
解读使用dispatch_set_target_queue将多个串行的queue指定到了同一目标，那么着多个串行queue在目标queue上就是同步执行的，不再是并行执行。

 

```
/*
    设置目标队列,使多个serial queue在目标queue上一次只有一个执行
 */
- (void)setTarget {
    //1.创建目标队列
    dispatch_queue_t targetQueue = dispatch_queue_create("test.target.queue", DISPATCH_QUEUE_SERIAL);
    
    //2.创建3个串行队列
    dispatch_queue_t queue1 = dispatch_queue_create("test.1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("test.2", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue3 = dispatch_queue_create("test.3", DISPATCH_QUEUE_SERIAL);
    
    //3.将3个串行队列分别添加到目标队列
    dispatch_set_target_queue(queue1, targetQueue);
    dispatch_set_target_queue(queue2, targetQueue);
    dispatch_set_target_queue(queue3, targetQueue);

    
    dispatch_async(queue1, ^{
        NSLog(@"queue1 start");
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@"1-thread - %@ ",[NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
        NSLog(@"queue1 end");
    });
    
    /*
        即使把下面的代码打开 queue1 设置为 DISPATCH_QUEUE_CONCURRENT 设置dispatch_set_target_queue 之后 仍然是串行执行
     按道理来讲 应该是并发执行才对吧？ 不解为什么？？？？
     */
    
//    dispatch_async(queue1, ^{
//        NSLog(@"queue11 start");
//        for (NSInteger i = 0; i < 2; i++) {
//            NSLog(@"11-thread - %@ ",[NSThread currentThread]);
//            [NSThread sleepForTimeInterval:1];
//        }
//        NSLog(@"queue11 end");
//    });
//    dispatch_async(queue1, ^{
//        NSLog(@"queue12 start");
//        for (NSInteger i = 0; i < 2; i++) {
//            NSLog(@"12-thread - %@ ",[NSThread currentThread]);
//            [NSThread sleepForTimeInterval:1];
//        }
//        NSLog(@"queue12 end");
//    });
//
    dispatch_async(queue2, ^{
        NSLog(@"queue2 start");
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@"2-thread - %@ ",[NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
        NSLog(@"queue2 end");
    });
    dispatch_async(queue3, ^{
        NSLog(@"queue3 start");
        for (NSInteger i = 0; i < 2; i++) {
            NSLog(@"3-thread - %@ ",[NSThread currentThread]);
            [NSThread sleepForTimeInterval:1];
        }
        NSLog(@"queue3 end");
    });
 
}


如果没有 一下三行代码 

 dispatch_set_target_queue(queue1, targetQueue);
 dispatch_set_target_queue(queue2, targetQueue);
 dispatch_set_target_queue(queue3, targetQueue);

 执行结果是这样的
 
 queue2 start
queue3 start
queue1 start
3-thread - <NSThread: 0x600000196c00>{number = 6, name = (null)}
1-thread - <NSThread: 0x600000170400>{number = 4, name = (null)}
2-thread - <NSThread: 0x60000018c840>{number = 5, name = (null)}
2-thread - <NSThread: 0x60000018c840>{number = 5, name = (null)}
3-thread - <NSThread: 0x600000196c00>{number = 6, name = (null)}
1-thread - <NSThread: 0x600000170400>{number = 4, name = (null)}
queue2 end
queue3 end
queue1 end
 
 
 
设置目标队列之后 是
queue1 start
1-thread - <NSThread: 0x600002205400>{number = 5, name = (null)}
1-thread - <NSThread: 0x600002205400>{number = 5, name = (null)}
queue1 end
queue2 start
2-thread - <NSThread: 0x600002205400>{number = 5, name = (null)}
2-thread - <NSThread: 0x600002205400>{number = 5, name = (null)}
queue2 end
queue3 start
3-thread - <NSThread: 0x600002205400>{number = 5, name = (null)}
3-thread - <NSThread: 0x600002205400>{number = 5, name = (null)}
queue3 end

```
结论：

>dispatch_set_target_queue 可以让三个 串行执行的队列之间 串行执行。如果没有设置 target 队列 那么三个串行队列之间是并发执行的。设置之后是串行执行。但是如果目标队列 target 是 是并发队列 那么这三个队列依然是并发执行，那么就失去了设置target的意义

### 6.2  问题 

> 问题： queue1 是并发队列 ，异步执行，target 是串行队列，设置 target 之后为什么 queue1 是串行执行？？ 

> 解答：dispatch_set_target_queue 设置的不仅仅是优先级和target 队列一样，队列的性质也一样了。如果target 是并行/串行 那么queue1 无论是并行/串行 都和target一样了。


## 7 线程同步

### 7.1 Dispatch Group 调度组

&emsp; 有时候我们会有这样的需求：分别异步执行2个耗时任务，然后当2个耗时任务都执行完毕后再回到主线程执行任务。这时候我们可以用到 GCD 的队列组。


- 调用队列组的 dispatch_group_async 先把任务放到队列中，然后将队列放入队列组中。或者使用队列组的 dispatch_group_enter、dispatch_group_leave 组合 来实现
dispatch_group_async。
- 调用队列组的 dispatch_group_notify 回到指定线程执行任务。或者使用 dispatch_group_wait 回到当前线程继续向下执行（会阻塞当前线程）。

#### 7.1.1 Dispatch_group_notify
```
- (void)dispathcGroup {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"group---begin");
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue1 = dispatch_queue_create("com.jiwuchao.www1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("com.jiwuchao.www2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue1, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue2, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步任务1、任务2都执行完毕后，回到主线程执行下边任务
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"4---%@",[NSThread currentThread]);
        }
        NSLog(@"group---end");
    });
}
```
结论：

&emsp;从dispatch_group_notify相关代码运行输出结果可以看出：
当所有任务都执行完成之后，才执行dispatch_group_notify block 中的任务

#### 7.1.2 Dispath_group_wait
&emsp;暂停当前线程（阻塞当前线程），等待指定的 group 中的任务执行完成后，才会往下继续执行



```
- (void)dispathcGroupWait {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"group---begin");
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue1 = dispatch_queue_create("com.jiwuchao.www1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("com.jiwuchao.www2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_async(group, queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue1, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
    });
    
    dispatch_group_async(group, queue2, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
    });
    // 阻塞 20 秒
    dispatch_group_wait(group, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(20 * NSEC_PER_SEC)));
    NSLog(@"group---end");
    

}


打印：


currentThread---<NSThread: 0x600003629280>{number = 1, name = main}
group---begin
2---<NSThread: 0x60000367d240>{number = 3, name = (null)}
1---<NSThread: 0x600003656580>{number = 5, name = (null)}
3---<NSThread: 0x6000036b5dc0>{number = 6, name = (null)}
2---<NSThread: 0x60000367d240>{number = 3, name = (null)}
3---<NSThread: 0x6000036b5dc0>{number = 6, name = (null)}
1---<NSThread: 0x600003656580>{number = 5, name = (null)}
group---end

```
结论：

>从dispatch_group_wait相关代码运行输出结果可以看出：
当所有任务执行完成之后，才执行 dispatch_group_wait 之后的操作。但是，使用dispatch_group_wait 会阻塞当前线程。

#### 7.1.3 dispatch_group_enter、dispatch_group_leave

- dispatch_group_enter 标志着一个任务追加到 group，执行一次，相当于 group 中未执行完毕任务数+1
- dispatch_group_leave 标志着一个任务离开了 group，执行一次，相当于 group 中未执行完毕任务数-1。
- 当 group 中未执行完毕任务数为0的时候，才会使dispatch_group_wait解除阻塞，以及执行追加到dispatch_group_notify中的任务。


```

- (void)dispathcGroupLeave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);
    NSLog(@"group---begin");
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.www", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue1 = dispatch_queue_create("com.jiwuchao.www1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t queue2 = dispatch_queue_create("com.jiwuchao.www2", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"1---%@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue1, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"2---%@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_enter(group);
    dispatch_async(queue2, ^{
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];
            NSLog(@"3---%@",[NSThread currentThread]);
        }
        dispatch_group_leave(group);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        // 等前面的异步操作都执行完毕后，回到主线程.
        for (int i = 0; i < 2; ++i) {
            [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
            NSLog(@"4---%@",[NSThread currentThread]);      // 打印当前线程
        }
        NSLog(@"group---end");
    });

}

打印:

currentThread---<NSThread: 0x60000359c280>{number = 1, name = main}
group---begin
2---<NSThread: 0x6000035f2200>{number = 4, name = (null)}
1---<NSThread: 0x600003518ec0>{number = 5, name = (null)}
3---<NSThread: 0x60000353d4c0>{number = 8, name = (null)}
2---<NSThread: 0x6000035f2200>{number = 4, name = (null)}
3---<NSThread: 0x60000353d4c0>{number = 8, name = (null)}
1---<NSThread: 0x600003518ec0>{number = 5, name = (null)}
4---<NSThread: 0x60000359c280>{number = 1, name = main}
4---<NSThread: 0x60000359c280>{number = 1, name = main}
group---end
```


结论：

>从dispatch_group_enter、dispatch_group_leave相关代码运行结果中可以看出：当所有任务执行完成之后，才执行 dispatch_group_notify 中的任务。这里的dispatch_group_enter、dispatch_group_leave组合，其实等同于dispatch_group_async。


#### 7.1.4 iOS 多个异步网络请求全部返回后再执行具体逻辑的方法

- [x] 注意看这片文章


[dispatch_group_async，dispatch_group_enter 和 dispatch_group_leave 可以对group进行更细致的处理](https://www.cnblogs.com/breezemist/p/5667776.html)


### 7.2  dispatch_barrier_async 和 dispatch_barrier_sync

#### 7.2.1 dispatch_barrier_async

&emsp;dispatch_barrier_async的作用是等待队列的前面的任务执行完毕后，才执行dispatch_barrier_async的block里面的任务,不会阻塞当前线程

```
- (void)barrierAsync {
    
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.barrierAsync", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2 - %@",[NSThread currentThread]);
        }
    });
    
    dispatch_barrier_async(queue, ^{
        NSLog(@"dispatch_barrier_async 任务");
    });
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"4 - %@",[NSThread currentThread]);
        }
    });
    NSLog(@"当前线程阻塞住了吗？没有");
}

打印:

当前线程阻塞住了吗？没有
1 - <NSThread: 0x600001128e00>{number = 3, name = (null)}
2 - <NSThread: 0x60000112fc40>{number = 4, name = (null)}
1 - <NSThread: 0x600001128e00>{number = 3, name = (null)}
2 - <NSThread: 0x60000112fc40>{number = 4, name = (null)}
dispatch_barrier_async 任务
3 - <NSThread: 0x60000112fc40>{number = 4, name = (null)}
4 - <NSThread: 0x600001128e00>{number = 3, name = (null)}
4 - <NSThread: 0x600001128e00>{number = 3, name = (null)}
3 - <NSThread: 0x60000112fc40>{number = 4, name = (null)}

```

结论：
1. dispatch_barrier_async 不会阻塞当前线程
2. dispatch_barrier_async 会等到前面的任务执行完之后再执行后面的任务

#### 7.2.2 dispatch_barrier_sync

&emsp;dispatch_barrier_sync的作用是等待队列的前面的任务执行完毕后，才执行dispatch_barrier_async的block里面的任务,阻塞当前线程

```
- (void)barrierSync {
    // 创建一个并发队列
    dispatch_queue_t queue = dispatch_queue_create("com.jiwuchao.barrierAsync", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"1 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"2 - %@",[NSThread currentThread]);
        }
    });
  
    dispatch_barrier_sync(queue, ^{
        NSLog(@"dispatch_barrier_sync 任务");
        [NSThread sleepForTimeInterval:3];
    });
    
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"3 - %@",[NSThread currentThread]);
        }
    });
    dispatch_async(queue, ^{
        for (NSInteger i = 0; i < 2; i++) {
            [NSThread sleepForTimeInterval:1];
            NSLog(@"4 - %@",[NSThread currentThread]);
        }
    });
    NSLog(@"当前线程阻塞住了吗？阻塞住了");
}
 
打印:

1 - <NSThread: 0x600003475640>{number = 3, name = (null)}
2 - <NSThread: 0x600003475680>{number = 4, name = (null)}
2 - <NSThread: 0x600003475680>{number = 4, name = (null)}
1 - <NSThread: 0x600003475640>{number = 3, name = (null)}
dispatch_barrier_sync 任务
当前线程阻塞住了吗？阻塞住了
4 - <NSThread: 0x600003475640>{number = 3, name = (null)}
3 - <NSThread: 0x600003475680>{number = 4, name = (null)}
3 - <NSThread: 0x600003475680>{number = 4, name = (null)}
4 - <NSThread: 0x600003475640>{number = 3, name = (null)}

```

&emsp; "当前线程阻塞住了吗？阻塞住了" 在当前线程中的输出 等到dispatch_barrier_sync 执行之后才执行

结论：

1. dispatch_barrier_sync 会阻塞当前线程（主线程/非主线程）
2. dispatch_barrier_sync会等到前面的任务执行完之后再执行后面的任务



### 7.3 Dispatch Semaphore 信号量


&emsp;GCD 中的信号量是指 Dispatch Semaphore，是持有计数的信号。类似于过高速路收费站的栏杆。可以通过时，打开栏杆，不可以通过时，关闭栏杆。在 Dispatch Semaphore 中，使用计数来完成这个功能，计数为0时等待，不可通过。计数为1或大于1时，计数减1且不等待，可通过。
Dispatch Semaphore 提供了三个函数。

1. dispatch_semaphore_create：创建一个Semaphore并初始化信号的总量
2. dispatch_semaphore_signal：发送一个信号，让信号总量加1
3. dispatch_semaphore_wait：可以使总信号量减1，当信号总量为0时就会一直等待（阻塞所在线程），否则就可以正常执行。

>注意：信号量的使用前提是：想清楚你需要处理哪个线程等待（阻塞），又要哪个线程继续执行，然后使用信号量


>Dispatch Semaphore 在实际开发中主要用于：

1. 保持线程同步，将异步执行任务转换为同步执行任务
2. 保证线程安全，为线程加锁

#### 7.3.1 Dispatch Semaphore 线程同步


```
- (void)synchronization {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    __block int number = 0;
    dispatch_async(queue, ^{
        // 追加任务1
        [NSThread sleepForTimeInterval:2];              // 模拟耗时操作
        NSLog(@"1---%@",[NSThread currentThread]);      // 打印当前线程
        
        number = 100;
        
        dispatch_semaphore_signal(semaphore);
    });
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    NSLog(@"semaphore---end,number = %zd",number);
}

```

结论:

>Dispatch Semaphore 实现线程同步的代码可以看到：

1. semaphore---end 是在执行完 number = 100; 之后才打印的。而且输出结果 number 为 100。
2. 这是因为异步执行不会做任何等待，可以继续执行任务。异步执行将任务1追加到队列之后，不做等待，接着执行dispatch_semaphore_wait方法。此时 semaphore == 0，当前线程进入等待状态。然后，异步任务1开始执行。任务1执行到dispatch_semaphore_signal之后，总信号量，此时 semaphore == 1，dispatch_semaphore_wait方法使总信号量减1，正在被阻塞的线程（主线程）恢复继续执行。最后打印semaphore---end,number = 100。这样就实现了线程同步，将异步执行任务转换为同步执行任务。

#### 7.3.2 线程安全


```
- (void)threadSave {
    NSLog(@"currentThread---%@",[NSThread currentThread]);  // 打印当前线程
    NSLog(@"semaphore---begin");
    
    self.semaphoreLock = dispatch_semaphore_create(1);
    
    self.ticketSurplusCount = 10;
    
    dispatch_queue_t queue1 = dispatch_queue_create("wuchao.www1", DISPATCH_QUEUE_SERIAL);
    
    dispatch_queue_t queue2 = dispatch_queue_create("wuchao.www2", DISPATCH_QUEUE_SERIAL);
    
    __weak typeof(self) weakSelf = self;
    dispatch_async(queue1, ^{
        [weakSelf saleTicketSafe];
    });
    
    dispatch_async(queue2, ^{
        [weakSelf saleTicketSafe];
    });
}

- (void)saleTicketSafe {
    
    while (1) {
        // 此时信号量减1 如果信号量减一之后小于或等于0 则等待
        dispatch_semaphore_wait(self.semaphoreLock, DISPATCH_TIME_FOREVER);
        if (self.ticketSurplusCount > 0) {  //如果还有票，继续售卖
            self.ticketSurplusCount--;
            NSLog(@"%@", [NSString stringWithFormat:@"剩余票数：%ld 窗口：%@", (long)self.ticketSurplusCount, [NSThread currentThread]]);
            [NSThread sleepForTimeInterval:0.2];
        } else { //如果已卖完，关闭售票窗口
            NSLog(@"所有火车票均已售完");
            // 信号量加1
            dispatch_semaphore_signal(self.semaphoreLock);
            break;
        }
        
        // 相当于解锁 信号量加1
        dispatch_semaphore_signal(self.semaphoreLock);
    }
    
}

打印:

currentThread---<NSThread: 0x60000331fbc0>{number = 1, name = main}
semaphore---begin
剩余票数：9 窗口：<NSThread: 0x60000337d8c0>{number = 4, name = (null)}
剩余票数：8 窗口：<NSThread: 0x60000338ccc0>{number = 5, name = (null)}
剩余票数：7 窗口：<NSThread: 0x60000337d8c0>{number = 4, name = (null)}
剩余票数：6 窗口：<NSThread: 0x60000338ccc0>{number = 5, name = (null)}
剩余票数：5 窗口：<NSThread: 0x60000337d8c0>{number = 4, name = (null)}
剩余票数：4 窗口：<NSThread: 0x60000338ccc0>{number = 5, name = (null)}
剩余票数：3 窗口：<NSThread: 0x60000337d8c0>{number = 4, name = (null)}
剩余票数：2 窗口：<NSThread: 0x60000338ccc0>{number = 5, name = (null)}
剩余票数：1 窗口：<NSThread: 0x60000337d8c0>{number = 4, name = (null)}
剩余票数：0 窗口：<NSThread: 0x60000338ccc0>{number = 5, name = (null)}
所有火车票均已售完
所有火车票均已售完


```
可以看出，在考虑了线程安全的情况下，使用 dispatch_semaphore
机制之后，保证了在多线程下访问ticketSurplusCount 的正确性

## 8 dispatch_after

>dispatch_after  函数并不是在指定时间之后才开始执行处理，而是在指定时间之后将任务追加到主队列中。严格来说，这个时间并不是绝对准确的，但想要大致延迟执行任务，dispatch_after函数是很有效的。

## 9 dispatch_once

> dispatch_once 函数能保证某段代码在程序运行过程中只被执行1次，并且即使在多线程的环境下，dispatch_once也可以保证线程安全。


```
+ (instancetype)shared {
    static Download *download = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        download = [[Download alloc] init];
    });
    return download;
}
```





## 10 dispath_apply

&emsp;dispatch_apply函数是dispatch_sync函数和Dispatch Group的关联API,该函数按指定的次数将指定的Block追加到指定的Dispatch Queue中,并等到全部的处理执行结束

- [ ] 注意: dispatch_apply 会阻塞当前线程

```

//    第一个参数为重复次数；
//    第二个参数为追加对象的Dispatch Queue；
//    第三个参数为追加的操作，追加的Block中带有参数，这是为了按第一个参数重复追加Block并区分各个Block而使用。

dispatch_apply(<#size_t iterations#>, <#dispatch_queue_t  _Nullable queue#>, <#^(size_t)block#>)
```


```
{
//    第一个参数为重复次数；
//    第二个参数为追加对象的Dispatch Queue；
//    第三个参数为追加的操作，追加的Block中带有参数，这是为了按第一个参数重复追加Block并区分各个Block而使用。
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.wuchaoji.www", DISPATCH_QUEUE_CONCURRENT);
     dispatch_queue_t serialqueue = dispatch_queue_create("com.wuchaoji.www", DISPATCH_QUEUE_SERIAL);
    dispatch_apply(5, concurrentQueue, ^(size_t index) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"concurrentQueue index = %ld",index);
    });
    NSLog(@"concurrentQueue 执行完");
    
    
    dispatch_apply(5, serialqueue, ^(size_t index) {
        NSLog(@"serialqueue index = %ld",index);
    });
    NSLog(@"serialqueue 执行完");
    /*
     输出
     concurrentQueue index = 0
     concurrentQueue index = 2
     concurrentQueue index = 1
     concurrentQueue index = 3
     concurrentQueue index = 4
     concurrentQueue 执行完
     serialqueue index = 0
     serialqueue index = 1
     serialqueue index = 2
     serialqueue index = 3
     serialqueue index = 4
     serialqueue 执行完
     
     concurrentQueue 无序
     serialqueue 有序
     */
    
}
```


dispatch_apply导致的死锁
## 11 dispatch_suspend/dispatch_resume 暂停/恢复队列

>dispatch_suspend会挂起dispatch queue，但并不意味着当前正在执行的任务会停下来，这只会导致不再继续执行还未执行的任务。
dispatch_resume会唤醒已挂起的dispatch queue。你必须确保它们成对调用。


```
- (void)suspendResume {
    dispatch_queue_t queue = dispatch_queue_create("com.test.gcd", DISPATCH_QUEUE_SERIAL);
    //任务1
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"任务1 ");
    });
    //任务2
    dispatch_async(queue, ^{
        [NSThread sleepForTimeInterval:5];
        NSLog(@"任务2");
    });

    [NSThread sleepForTimeInterval:1];
    //挂起队列
    NSLog(@"队列挂起此时已经开始执行任务1 但没有开始执行任务2");
    dispatch_suspend(queue);
    //延时10秒
    [NSThread sleepForTimeInterval:10];
    NSLog(@"恢复队列");
    //恢复队列
    dispatch_resume(queue);
    
    
}

打印

队列挂起此时已经开始执行任务1 但没有开始执行任务2
任务1 
恢复队列
任务2

```

## 12 dispatch_async 和 dispatch_sync

>他们的作用是将 任务（block）添加进指定的队列中。并根据是否为sync决定调用该函数的线程是否需要阻塞。
注意：这里调用该函数的线程并不执行 参数中指定的任务（block块），任务的执行者是GCD分配给任务所在队列的线程。

结论：调用dispatch_sync和dispatch_async的线程，并不一定是任务（block块）的执行者。

 

### 参考文档

1. https://bujige.net/blog/iOS-Complete-learning-GCD.html