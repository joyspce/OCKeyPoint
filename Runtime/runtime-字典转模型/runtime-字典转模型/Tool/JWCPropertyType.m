//
//  JWCPropertyType.m
//  runtime-字典转模型
//
//  Created by JiWuChao on 2018/8/17.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "JWCPropertyType.h"

#import "JWCExtensionConst.h"

#import "NSObject+Property.h"

@implementation JWCPropertyType

/**
 *  用于缓存一些常用类型的type，避免多次调用
 */
static NSMutableDictionary *cachedTypes_;
+ (void)load
{
    cachedTypes_ = [NSMutableDictionary dictionary];
}

+ (instancetype)propertyTypeWithAttributeString:(NSString *)string {
    return [[JWCPropertyType alloc] initWithTypeString:string];
}


- (instancetype)initWithTypeString:(NSString *)string {
    
    NSUInteger loc = 1;
    
    if ([string rangeOfString:@","].location == NSNotFound) {
        return self;
    }
    
    NSUInteger len = [string rangeOfString:@","].location - loc;
    NSString *typeCode = [string substringWithRange:NSMakeRange(loc, len)];
    
    if (!cachedTypes_[typeCode]) {
        NSLog(@"typeCode===>%@",typeCode);
        self = [super init];
        [self getTypeCode:typeCode];
        cachedTypes_[typeCode] = self;
    }
    return self;
}

- (void)getTypeCode:(NSString *)code {
    
    if ([code isEqualToString:MJPropertyTypeId]) {
        _idType = YES;
    } else if (code.length > 3 && [code hasPrefix:@"@\""]) {
        // 去掉@"和"，截取中间的类型名称
        _code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
        _typeClass = NSClassFromString(_code);
        _numberType = (_typeClass == [NSNumber class] || ([_typeClass isSubclassOfClass:[NSNumber class]]));
        _fromFoundation = [NSObject isClassFromFoundation:_typeClass];
    }
    
    // 是否为数字类型
    NSString *lowerCode = code.lowercaseString;
    NSArray *numberTypes = @[MJPropertyTypeInt, MJPropertyTypeShort, MJPropertyTypeBOOL1, MJPropertyTypeBOOL2, MJPropertyTypeFloat, MJPropertyTypeDouble, MJPropertyTypeLong, MJPropertyTypeChar];
    
    //boole类型是number类型的一种。

    if ([numberTypes containsObject:lowerCode]) {
        _numberType = YES;
        
        if ([lowerCode isEqualToString:MJPropertyTypeBOOL1]
            || [lowerCode isEqualToString:MJPropertyTypeBOOL2]) {
            _boolType = YES;
        }
    }
}







@end
