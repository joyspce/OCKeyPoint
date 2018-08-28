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

@property (nonatomic, strong) Son *son2;

@property (nonatomic, copy) NSString *textString;


@end

@implementation PushViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    Father *father  = [[Father alloc] init];
    Son *son = [[Son alloc] init];
    self.son2 = [[Son alloc] init];
    
    
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
    
    __weak typeof(self) weakself = self;
    [self.KVOController observe:_son2 keyPath:@"age" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"self.son2.age == %ld",(long)weakself.son2.age);//如果用self会导致强引用
    }];
    
    /*
         self 持有 KVOController 而 ‘self.KVOController observe:self keyPath:@"textString" ’ 导致 KVOController 持有self，形成循环引用
     */
    [self.KVOController observe:self keyPath:@"textString" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"self.textString == %@",(long)weakself.textString);
    }];
    
    /*
        正确写法 self.KVOController 换成 self.KVOControllerNonRetaining
        KVOControllerNonRetaining 对self 是弱引用
     */
    [self.KVOControllerNonRetaining observe:self keyPath:@"textString" options:NSKeyValueObservingOptionNew block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        NSLog(@"self.textString == %@",(long)weakself.textString);
    }];
    
    
    father.name = @"father-李四";
    father.age = 100;
    father.address = @"上海";
    
    son.name = @"小明";
    son.age = 21;
    
    self.son2.age = 32;
    self.textString = @"test";
    
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.btn setTintColor:[UIColor redColor]];
    [self.btn setTitle:@"push" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(push) forControlEvents:UIControlEventTouchUpInside];
    self.btn.backgroundColor = [UIColor blueColor];
    [self.view addSubview:self.btn];
}

- (void)push {
    //此时的当pop出去时 son 和 father 释放掉 那么属性 kvoController 也被释放，就会走到FBKVOController 中的dealloc 在dealloc中调用
    /*
     - (void)dealloc
     {
        [self unobserveAll];
        pthread_mutex_destroy(&_lock);
     }
     */
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
