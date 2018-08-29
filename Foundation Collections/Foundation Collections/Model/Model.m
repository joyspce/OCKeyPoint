//
//  Model.m
//  Foundation Collections
//
//  Created by JiWuChao on 2018/8/29.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "Model.h"

@implementation Model

+ (instancetype)initWithName:(NSString *)name withAge:(NSInteger)age {
    
    return [[Model alloc] initWithName:name withAge:age];
}

- (instancetype)initWithName:(NSString *)name withAge:(NSInteger)age {
    Model *model = [[Model alloc] init];
    model.name = name;
    model.age = age;
    return model;
}


+ (instancetype)initWithAge:(NSInteger)age {
    return [[Model alloc] initWithName:@"" withAge:age];
}

+ (instancetype)initWithName:(NSString *)name {
    return [[Model alloc] initWithName:name withAge:0];
}




@end
