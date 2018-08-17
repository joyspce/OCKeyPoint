//
//  NSObject+Property.h
//  runtime-字典转模型
//
//  Created by JiWuChao on 2018/8/17.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JWCProperty.h"

@interface NSObject (Property)

+ (NSArray *)propertyList;

+ (BOOL)isClassFromFoundation:(Class)c;

@end
