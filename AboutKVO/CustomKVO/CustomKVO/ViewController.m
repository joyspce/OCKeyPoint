//
//  ViewController.m
//  CustomKVO
//
//  Created by JiWuChao on 2018/8/22.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "Father.h"

#import "NSObject+KVO.h"

@interface ViewController ()

// 参考：https://www.jianshu.com/p/bf053a28accb

@property (nonatomic,strong) Father *father;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.father = [[Father alloc] init];
    
    [self.father jw_addObserver:self forKey:NSStringFromSelector(@selector(name)) withBlock:^(id observerObj, NSString *observerKey, id oldValue, id newValue) {
        NSLog(@"oldValue: %@ | newValue: %@",oldValue,newValue);
    }];
    self.father.name = @"张三";
    
    self.father.name = @"李四";
}


- (void)dealloc {
    [self.father jw_removeObserver:self forKey:@"name"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
