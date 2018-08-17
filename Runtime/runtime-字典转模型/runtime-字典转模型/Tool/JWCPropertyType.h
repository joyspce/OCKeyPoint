//
//  JWCPropertyType.h
//  runtime-字典转模型
//
//  Created by JiWuChao on 2018/8/17.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

//https://github.com/huang303513/iOSKeyPointExploration.git

@interface JWCPropertyType : NSObject

/** 类型标识符 */
@property (nonatomic, copy) NSString *code;
/** 是否为id类型 */
@property (nonatomic, assign,readonly,getter=isIdType) BOOL idType;
/** 是否为基本数字类型：int、float等 */
@property (nonatomic, assign, readonly,getter=isNumberType) BOOL numberType;
/** 是否为BOOL类型 */
@property (nonatomic, assign, readonly,getter=isBoolType) BOOL boolType;
/** 对象类型（如果是基本数据类型，此值为nil） */
@property (nonatomic, strong) Class typeClass;
/** 类型是否来自于Foundation框架，比如NSString、NSArray */
@property (nonatomic, assign, readonly, getter=isFromFoundation) BOOL fromFoundation;

+ (instancetype)propertyTypeWithAttributeString:(NSString *)string;

@end
