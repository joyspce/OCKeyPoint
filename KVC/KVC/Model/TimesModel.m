//
//  TimesModel.m
//  KVC
//
//  Created by JiWuChao on 2018/9/4.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "TimesModel.h"

@interface TimesModel()

@property (nonatomic,readwrite,assign) NSUInteger count;

@property (nonatomic,copy) NSString* arrName;

@end


@implementation TimesModel

- (void)incrementCount {
    self.count ++;
}


- (NSUInteger)countOfNumbers {
    return  self.count;
}

- (id)objectInNumbersAtIndex:(NSUInteger)index {
    return @(index * 2);
}




+ (BOOL)accessInstanceVariablesDirectly {
    return YES;
}

/*
    查找：
        第一步：
            从1,2,3,4,5步中按顺序查找如果找到之后立即返回不在继续寻找
        第二步:
            如果第一步没找到 则查找6 和 7 的组合 如果有则返回 如果没有则 查找 6和8的组合 如果有则返回
        
 
 
 */


//-(NSInteger)getNum{                 //1,自己一个一个注释试
//    return 10;
//}
//-(NSInteger)num{                       //2
//    return 11;
//}
//-(NSInteger)isNum{                    //3
//    return 12;
//}
//- (NSInteger)_getNum {                // 4
//    return 14;
//}
//- (NSInteger)_num {                     // 5
//    return 15;
//}


/**
 第六和第七必须同时实现

 @return <#return value description#>
 */
//- (NSInteger)countOfNum { // 6
//    return 3;// 表示 执行 objectInNumAtIndex:(NSUInteger)index 方法的次数
//}

//- (id)objectInNumAtIndex:(NSUInteger)index {// 7 返回的是 NSKeyValueArray 类型
//    return @(index * 3);
//}

//- (id)numAtIndexes:(NSUInteger)index {//8
//    return @(index * 1);
//}

- (NSUInteger)enumeratorOfNum {
    return 3;
}

- (id)memberOfNum:(NSUInteger)index {
    return @(index * 2);
}



@end
