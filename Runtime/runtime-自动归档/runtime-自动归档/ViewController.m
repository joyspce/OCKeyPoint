//
//  ViewController.m
//  runtime-自动归档
//
//  Created by JiWuChao on 2018/8/14.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "Model.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Model *m = [Model testModel];
    NSLog(@"name:%@,age = %@,money = %d,_floatValue = %f,high = %f",m.name,m.age,m.money,m._floatValue,m.high);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
