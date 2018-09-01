//
//  NSMapTableVC.m
//  Foundation Collections
//
//  Created by JiWuChao on 2018/8/28.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "NSMapTableVC.h"

#import "Model.h"

@interface NSMapTableVC ()

@end

@implementation NSMapTableVC

/*
    NSMapTable 不是线程安全的

    NSMapTable 是 NSDictionary 的通用版本。和 NSDictionary / NSMutableDictionary 不同的是，NSMapTable 具有下面这些特性：
 
    NSDictionary / NSMutableDictionary 对键进行拷贝，对值持有强引用。
    NSMapTable 是可变的，没有不可变的对应版本。
    NSMapTable 可以持有键和值的弱引用，当键或者值当中的一个被释放时，整个这一项就会被移除掉。
    NSMapTable 可以在加入成员时进行 copy 操作。
    NSMapTable 可以存储任意的指针，通过指针来进行相等性和散列检查。
 注意： NSMapTable 专注于强引用和弱引用，意外着 Swift 中流行的值类型是不适用的，只能用于引用类型。
 

 
 */



- (void)viewDidLoad {
    [super viewDidLoad];
    NSMapTable <id,NSMutableSet<Model*>*>*map = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSPointerFunctionsWeakMemory capacity:10];
    
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
    
}


- (NSMutableSet *)models {
    NSMutableSet *ms = [[NSMutableSet alloc] init];
    for (NSInteger i = 0; i < 2; i++) {
        Model *m = [[Model alloc] init];
        m.age = i * 10 + i;
        m.name = [NSString stringWithFormat:@"我是第%ld个",i];
        [ms addObject:m];
    }
    return ms;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
