//
//  Human.h
//  Foundation Collections
//
//  Created by JiWuChao on 2018/8/29.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Human : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, strong) NSMutableArray <Human *>*family;

+(instancetype)initWithName:(NSString *)name withAge:(NSInteger)age;

+(instancetype)initWithName:(NSString *)name;

+(instancetype)initWithAge:(NSInteger)age;


@end


