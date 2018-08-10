//
//  ViewController.m
//  runtime-消息转发
//
//  Created by JiWuChao on 2018/8/10.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Person *p = [[Person alloc] init];
//    if ([p respondsToSelector:@selector(eatApple)]) {
        [p eatApple];
//    } else {
//        NSLog(@"no responds");
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
