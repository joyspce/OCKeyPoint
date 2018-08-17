//
//  JWCProperty.h
//  runtime-字典转模型
//
//  Created by JiWuChao on 2018/8/17.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <objc/runtime.h>

#import "JWCPropertyType.h"

@interface JWCProperty : NSObject
//属性的名字
@property (nonatomic, copy) NSString *name;
//成员属性的类型
@property (nonatomic, strong) JWCPropertyType *type;

+ (instancetype)propertyWithProperty:(objc_property_t)property;


@end
