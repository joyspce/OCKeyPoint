//
//  PeopleModel.h
//  runtime-字典转模型
//
//  Created by JiWuChao on 2018/8/17.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AnimalModel.h"

@interface PeopleModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) float hight;

@property (nonatomic, strong) NSNumber *wight;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, copy) NSString *address;

@property (nonatomic, strong) AnimalModel *ani;

@end
