//
//  PushViewController.m
//  FBKVOController
//
//  Created by JiWuChao on 2018/8/27.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "PushViewController.h"
#import "FBKVOController/FBKVOController.h"

#import "NSObject+FBKVOController.h"

#import "Father.h"

#import "Son.h"

@interface PushViewController ()

//@property (nonatomic,strong) Father *father;
//
//@property (nonatomic, strong) Son *son;

@property (nonatomic, strong) UIButton *btn;


@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   __block Father *father  = [[Father alloc] init];
   __block Son *son = [[Son alloc] init];
    
    [self.KVOController observe:father keyPath:@"name" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"father.name == %@",father.name);
    }];
    [self.KVOController observe:father keyPath:@"age" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"father.age == %ld",(long)father.age);
    }];
    [self.KVOController observe:father keyPath:@"address" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"father.address == %ld",(long)father.address);
    }];
    
    [self.KVOController observe:son keyPath:@"name" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"son.name == %@",son.name);
    }];
    [self.KVOController observe:son keyPath:@"age" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"son.age == %ld",(long)son.age);
    }];
    
    
    father.name = @"father-李四";
    father.age = 100;
    father.address = @"上海";
    
    son.name = @"小明";
    son.age = 21;
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.btn setTintColor:[UIColor redColor]];
    [self.btn setTitle:@"push" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    self.btn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.btn];
}

- (void)push {
    //此时的当pop出去时 son 和 father 释放掉 那么kvoController 中
    [self.navigationController popViewControllerAnimated:true];
    
}

- (void)dealloc {
    NSLog(@"结束了");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
