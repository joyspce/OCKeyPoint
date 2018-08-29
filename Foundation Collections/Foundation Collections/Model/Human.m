//
//  Human.m
//  Foundation Collections
//
//  Created by JiWuChao on 2018/8/29.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "Human.h"

@implementation Human

+ (instancetype)initWithName:(NSString *)name withAge:(NSInteger)age {
    
    return [[Human alloc] initWithName:name withAge:age];
}

- (instancetype)initWithName:(NSString *)name withAge:(NSInteger)age {
    Human *model = [[Human alloc] init];
    model.name = name;
    model.age = age;
    model.family = [[NSMutableArray alloc] init];
    [model.family addObject:model];
    return model;
}


+ (instancetype)initWithAge:(NSInteger)age {
    return [[Human alloc] initWithName:@"" withAge:age];
}

+ (instancetype)initWithName:(NSString *)name {
    return [[Human alloc] initWithName:name withAge:0];
}

- (void)dealloc {
    self.name = nil;
    self.family = nil;
    NSLog(@"human dealloc");
}


@end
