//
//  ViewController.m
//  touchEvent
//
//  Created by JiWuChao on 2018/12/15.
//  Copyright © 2018 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "TouchView.h"

#import "EVentDelivery.h"

#import "BigThanSuper.h"
//https://www.jianshu.com/p/2e074db792ba
@interface ViewController ()

@property (nonatomic,strong) TouchView *touch;

@property (nonatomic,strong) EVentDelivery *delivery;


@property (nonatomic,strong) BigThanSuper *bigThanSuper;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.touch = [[TouchView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    self.touch.backgroundColor = UIColor.redColor;
//    [self.view addSubview:self.touch];
    
    // 事件传递
    self.delivery = [[EVentDelivery alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.delivery];
    
    [self bigThanSuper];
    
}

//    超出父视图响应的问题解决方案
- (BigThanSuper *)bigThanSuper {
    if (!_bigThanSuper) {
        _bigThanSuper = [[BigThanSuper alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
        [self.view addSubview:_bigThanSuper];
    }
    return _bigThanSuper;
}


@end
