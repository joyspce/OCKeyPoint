//
//  Father.h
//  Category&&Extension
//
//  Created by JiWuChao on 2018/8/21.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Father : NSObject

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *address;

/*
    分类中也有这个方法 这个方法就不调用了，即被category 中的同名方法替换掉了
 
    1)、category的方法没有“完全替换掉”原来类已经有的方法，也就是说如果category和原来类都有methodA，那么category附加完成之后，类的方法列表里会有两个methodA
 
    2)、category的方法被放到了新方法列表的前面，而原来类的方法被放到了新方法列表的后面，这也就是我们平常所说的category的方法会“覆盖”掉原来类的同名方法，这是因为运行时在查找方法的时候是顺着方法列表的顺序查找的，它只要一找到对应名字的方法，就会停止查找
  */

- (void)goShoping;

@end
