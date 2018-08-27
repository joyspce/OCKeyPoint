//
//  ViewController.m
//  FBKVOController
//
//  Created by JiWuChao on 2018/8/27.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "FBKVOController/FBKVOController.h"

#import "NSObject+FBKVOController.h"

#import "Father.h"

#import "Son.h"


@interface ViewController ()

@property (nonatomic,strong) Father *father;

@property (nonatomic, strong) Son *son;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.father = [[Father alloc] init];
    self.son = [[Son alloc] init];
    
    [self.KVOController observe:self.father keyPath:@"name" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"father.name == %@",self.father.name);
    }];
    [self.KVOController observe:self.father keyPath:@"age" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"father.age == %ld",(long)self.father.age);
    }];
    [self.KVOController observe:self.father keyPath:@"address" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"father.address == %ld",(long)self.father.address);
    }];
    
    [self.KVOController observe:self.son keyPath:@"name" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"son.name == %@",self.son.name);
    }];
    [self.KVOController observe:self.son keyPath:@"age" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"son.age == %ld",(long)self.son.age);
    }];
    
    
    self.father.name = @"father-李四";
    self.father.age = 100;
    self.father.address = @"上海";
    
    self.son.name = @"小明";
    self.son.age = 21;
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
