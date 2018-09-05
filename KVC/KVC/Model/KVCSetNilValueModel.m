//
//  KVCSetNilValueModel.m
//  KVC
//
//  Created by JiWuChao on 2018/9/5.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "KVCSetNilValueModel.h"

@interface KVCSetNilValueModel()

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@end


@implementation KVCSetNilValueModel


- (void)setNilValueForKey:(NSString *)key {
    NSLog(@"value 为 nil");
}

@end
