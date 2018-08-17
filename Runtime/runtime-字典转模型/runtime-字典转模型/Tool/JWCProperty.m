//
//  JWCProperty.m
//  runtime-字典转模型
//
//  Created by JiWuChao on 2018/8/17.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "JWCProperty.h"

@implementation JWCProperty

+ (instancetype)propertyWithProperty:(objc_property_t)property {
    return [[JWCProperty alloc] initWithProperty:property];
}

- (instancetype)initWithProperty:(objc_property_t)property {
    if (self = [super init]) {
        _name = [NSString stringWithUTF8String:property_getName(property)];
        _type = [JWCPropertyType propertyTypeWithAttributeString:[NSString stringWithUTF8String:property_getAttributes(property)]];
    }
    return  self;
}


@end
