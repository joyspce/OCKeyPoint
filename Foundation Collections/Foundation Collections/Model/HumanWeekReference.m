//
//  HumanWeekReference.m
//  Foundation Collections
//
//  Created by JiWuChao on 2018/8/29.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "HumanWeekReference.h"

@implementation HumanWeekReference

+ (instancetype)initWithName:(NSString *)name withAge:(NSInteger)age {
    
    return [[HumanWeekReference alloc] initWithName:name withAge:age];
}

- (instancetype)initWithName:(NSString *)name withAge:(NSInteger)age {
    HumanWeekReference *model = [[HumanWeekReference alloc] init];
    model.name = name;
    model.age = age;
    model.family = [NSHashTable hashTableWithOptions:NSHashTableWeakMemory];
    [model.family addObject:model];
    return model;
}


+ (instancetype)initWithAge:(NSInteger)age {
    return [[HumanWeekReference alloc] initWithName:@"" withAge:age];
}

+ (instancetype)initWithName:(NSString *)name {
    return [[HumanWeekReference alloc] initWithName:name withAge:0];
}

- (void)dealloc {
    self.name = nil;
    self.family = nil;
    NSLog(@"HumanWeekReference dealloc");
}


@end
