//
//  Student.h
//  runtime属性获取
//
//  Created by JiWuChao on 2018/8/8.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "StudentProtocol.h"

@interface Student : NSObject<StudentProtocol>

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger age;

@property (nonatomic, assign) NSInteger heigh;



- (void)gotoSchool;

- (void)byBus;


@end
