//
//  ViewController.m
//  runtime 消息转发2--快速转发
//
//  Created by JiWuChao on 2018/8/12.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"
#import "Father.h"
#import "ForwardMessage.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Father *f = [[Father alloc]init];
//    [f gotoWork];
//    [f goHomeToCook];
    ForwardMessage *m = [[ForwardMessage alloc]init];
    [m forward];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
