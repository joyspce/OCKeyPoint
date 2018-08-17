//
//  ViewController.m
//  runtime-字典转模型
//
//  Created by JiWuChao on 2018/8/17.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "PeopleModel.h"

#import "NSObject+Property.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    PeopleModel *model = [[PeopleModel alloc] init];
    NSArray <JWCProperty *>*property = [PeopleModel propertyList];
    
    [property enumerateObjectsUsingBlock:^(JWCProperty * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"obj.name = %@\n",obj.name);
//        NSLog(@"objc.type.name = %@\n",obj.type.name);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
