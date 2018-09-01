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
    [self NSMutableSetTest];
    
    
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
    // 求两者的交集:
//    [m2Set intersectSet:m1Set];
//    NSLog(@"m2Set 和 m1Set 都有的元素是:%@",m2Set);
//    /*
//        结果：
//     {(
//         4,
//         5
//     )}
//     */
    //
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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
