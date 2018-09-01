//
//  NSCacheVC.m
//  Foundation Collections
//
//  Created by JiWuChao on 2018/8/28.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "NSCacheVC.h"

@interface NSCacheVC ()

@end

@implementation NSCacheVC


/*
 
 NSCache 是一个非常奇怪的集合。在 iOS 4 / Snow Leopard 中加入，默认为可变并且线程安全的。这使它很适合缓存那些创建起来代价高昂的对象。它自动对内存警告做出反应并基于可设置的”成本”清理自己。与 NSDictionary 相比，键是被 retain 而不是被 copy 的。
 
 NSCache 的回收方法是不确定的，在文档中也没有说明。向里面放一些类似图片那样超大的对象并不是一个好主意，有可能它在能回收之前就更快地把你的 cache 给填满了。(这是在 PSPDFKit 中很多跟内存有关的 crash 的原因，在使用自定义的基于 LRU 的链表缓存的代码之前，我们起初使用了 NSCache 存储事先渲染的图片。)
 
 可以对 NSCache 进行设置，这样它就能自动回收那些实现了 NSDiscardableContent 协议的对象。实现了该属性的一个比较常用的类是同时间加入的 NSPurgeableData，但是在 OS X 10.9 之前，它是非完全线程安全的 (也没有信息表明这个变化也影响到了 iOS，或者说在 iOS 7 中被修复了)。
 
 NSCache 性能
 那么相比起 NSMutableDictionary 来说，NSCache 表现如何呢？加入的线程安全必然会带来一些消耗。处于好奇，我也加入了一个自定义的线程安全的字典的子类 (PSPDFThreadSafeMutableDictionary)，它通过 OSSpinLock 实现同步的访问。
 
 类 / 时间 [ms]
 1.000.000 elements    iOS 7x64 Simulator    iPad Mini iOS 6
 NSMutableDictionary, adding    195.35    51.90    921.02
 PSPDFThreadSafeMutableDictionary, adding    248.95    57.03    1043.79
 NSCache, adding    557.68    395.92    1754.59
 NSMutableDictionary, random access    6.82    2.31    23.70
 PSPDFThreadSafeMutableDictionary, random access    9.09    2.80    32.33
 NSCache, random access    9.01    29.06    53.25
 
 NSCache 表现的相当好，随机访问跟我们自定义的线程安全字典一样快。如我们预料的，添加更慢一些，因为 NSCache 要多维护一个决定何时回收对象的成本系数。就这一点来看这不是一个非常公平的比较。有趣的是，在模拟器上运行效率要慢了几乎 10 倍。无论对 32 或 64 位的系统都是这样。而且看起来这个类已经在 iOS 7 中优化过，或者是受益于 64 位 runtime 环境。当在老的设备上测试时，使用 NSCache 的性能消耗就明显得多。
 
 iOS 6(32 bit) 和 iOS 7(64 bit) 的区别也很明显，因为 64 位运行时使用标签指针 (tagged pointer)，因此我们的 @(idx) boxing 要更为高效。
 

 
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
