//
//  Model.h
//  runtime-自动归档
//
//  Created by JiWuChao on 2018/8/14.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject<NSCopying>

@property (nonatomic,copy) NSString *name;

@property (nonatomic,strong) NSNumber *age;

@property (nonatomic,assign) int money;

@property (nonatomic,assign) float high;

@property (nonatomic, assign) const void *session;

@property (nonatomic, assign) float  _floatValue;


+ (Model *)testModel;


@end
