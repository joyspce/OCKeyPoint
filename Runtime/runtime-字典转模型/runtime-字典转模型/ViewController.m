//
//  ViewController.m
//  runtime-字典转模型
//
//  Created by JiWuChao on 2018/8/18.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "PeopleModel.h"

#import "NSObject+JWCKeyValueObject.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PeopleModel *model = [PeopleModel objectWithKeyValues:[self modelInfo]];
    
    NSLog(@"model.name = %@",model.name);
    NSLog(@"model.hight = %f",model.hight);
    NSLog(@"model.wight = %@",model.wight);
    NSLog(@"model.age = %ld",model.age);
    NSLog(@"model.address = %@",model.address);
    NSLog(@"model.ani.name = %@",model.ani.name);
    NSLog(@"model.ani.age = %ld ",(long)model.ani.age);
    
}

/*
 
 @property (nonatomic, copy) NSString *name;
 
 @property (nonatomic, assign) NSInteger hight;
 
 @property (nonatomic, strong) NSNumber *wight;
 
 @property (nonatomic, assign) NSInteger age;
 
 @property (nonatomic, copy) NSString *address;
 */



- (NSDictionary *)modelInfo {
    
    return @{@"name":@"张三",
             @"hight":@(190.22),
             @"wight":@(55.9),
             @"age":@"110",
             @"address":@"中国上海市闸北区",
             @"ani": @{ @"name":@"cat",
                       @"age": @(2),
                        @"live":@(1)
                       }
             };
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
