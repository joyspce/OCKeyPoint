//
//  Father.m
//  Category&&Extension
//
//  Created by JiWuChao on 2018/8/21.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "Father.h"

#import "Father+Ext.h"

#import "Father+Category.h"

@implementation Father

/*
 1)、在类的+load方法调用的时候，我们可以调用category中的方法，因为附加category到类的工作会先于+load方法的执行
 2)、+load的执行顺序是先类，后category，而category的+load执行顺序是根据编译顺序决定的。
 
 */
+ (void)load {
    [[[Father alloc] init] goHome];
}

- (void)gotoWork {
    NSLog(@"Extension中的方法：去工作");
}

- (void)goShoping {
    NSLog(@"原类: 去购物");
}

@end
