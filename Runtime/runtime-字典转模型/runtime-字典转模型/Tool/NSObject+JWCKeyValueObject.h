//
//  NSObject+JWCKeyValueObject.h
//  runtime-字典转模型
//
//  Created by JiWuChao on 2018/8/18.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JWCKeyValue <NSObject>

@optional
/**
 *  用于指定一个数组中元素的类型
 *
 *  @return 返回一个字典，值表示对应的类型
 */
+ (NSDictionary *) objectClassInArray;

/**
 *  实际开发中,服务器通常返回一个字段名为id,或者description的JSON数据,而这两个名字在OC中有特殊含义,如上所示,在定义属性的时候并不能使用这类名称.这时属性名与字典key不再是直接对应的关系,需要加入一层转换.
 *
 *  @return 返回一个对应的字典
 */
+ (NSDictionary *) replacedKeyFromPropertyName;

@end


@interface NSObject (JWCKeyValueObject)<JWCKeyValue>


/**
 *  返回解析的实例对象
 *
 *  @param keyValues 传入一个字典字典
 *
 *  @return 返回一个解析好的实例对象
 */
+ (instancetype)objectWithKeyValues:(id)keyValues;

@end
