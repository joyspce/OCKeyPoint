//
//  AnimalModel.h
//  runtime-字典转模型
//
//  Created by JiWuChao on 2018/8/20.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimalModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) BOOL live;

@end
