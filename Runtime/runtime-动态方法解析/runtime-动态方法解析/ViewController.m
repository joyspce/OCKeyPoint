//
//  ViewController.m
//  runtime-动态方法解析
//
//  Created by JiWuChao on 2018/8/12.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "Model.h"

#import "Father.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    Model *model = [[Model alloc] init];
//    model.name = @"www";
//    NSLog(@"model.name = %@",model.name);
    
    Father *father = [[Father alloc]init];
    [father gotoWork];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
