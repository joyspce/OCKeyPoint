//
//  NSSet&&NSOrderedSetVC.m
//  Foundation Collections
//
//  Created by JiWuChao on 2018/8/28.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "NSSet&&NSOrderedSetVC.h"

@interface NSSet__NSOrderedSetVC ()

@end

@implementation NSSet__NSOrderedSetVC

- (void)viewDidLoad {
    [super viewDidLoad];

//    [self NSSetTest];
//    [self NSMutableSetTest];
    [self NSOrderedSetTest];
    
}



- (void)NSSetTest {
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
    if ([set containsObject:@"www"]) {
        NSLog(@"包含");
    } else {
        NSLog(@"不包含");
    }
    
}


- (void)NSMutableSetTest {
    NSMutableSet *m1Set = [NSMutableSet setWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    NSMutableSet *m2Set = [NSMutableSet setWithObjects:@"4",@"5", nil];
    NSMutableSet *m3Set = [NSMutableSet setWithObjects:@"1",@"2",@"3",@"21", nil];
     //求两者的交集:
//    [m2Set intersectSet:m1Set];
//    NSLog(@"m2Set 和 m1Set 都有的元素是:%@",m2Set);
//    /*
//        结果：
//     {(
//         4,
//         5
//     )}
//     */
    // 差集
//    [m1Set minusSet:m2Set];
//
//    NSLog(@"m1Set 减去m2Set 中的内容之后--%@",m1Set);
//
//    /*
//     结果：
//     m1Set 减去m2Set 中的内容之后--{(
//         3,
//         1,
//         2
//     )}
//     */
    // 并集
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
}


- (void)NSOrderedSetTest {
    NSMutableOrderedSet *order1 = [NSMutableOrderedSet orderedSetWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
    NSMutableOrderedSet *order2 = [NSMutableOrderedSet orderedSetWithObjects:@"4",@"5", nil];
    NSMutableOrderedSet *order3 = [NSMutableOrderedSet orderedSetWithObjects:@"1",@"2",@"3",@"4222", nil];
    
    NSLog(@"order1 = %@",order1);
    /*
     结果: 有序
     order1 = {(
         1,
         2,
         3,
         4,
         5
     )}
     
     */
    
    // 交集
    
//    [order1 intersectsSet:[order2 set]];
//    NSLog(@"交集==%@",order1);
    
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
    // 差集
//    [order1 minusSet:[order2 set]];
//
//    NSLog(@"差集==%@",order1);
//
//    /* 结果
//     差集=={(
//         1,
//         2,
//         3
//     )}
//     */
    
    // 并集
//    [order2 unionSet:[order3 set]];
//
//    NSLog(@"并集==%@",order2);
    
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
//    NSArray *arr = [order1 array];
//    NSLog(@"arr:%@",arr);
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
//    NSSet *set = [order1 set];
//    NSLog(@"set:%@",set);
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
    
   NSString *idxValue = [order1 objectAtIndex:1];
    
    NSLog(@"idxValue = %@",idxValue);
    /*
     结果 ：
     
        idxValue = 2
     */
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
