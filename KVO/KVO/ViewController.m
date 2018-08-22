//
//  ViewController.m
//  KVO
//
//  Created by JiWuChao on 2018/8/22.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "Father.h"

@interface ViewController ()

@property (nonatomic,strong) Father *fa;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.fa = [[Father alloc] init];
    
    
    
    [self.fa addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];
    self.fa.name = @"张三";
}

/**
 调用此方法者 self.fa 是要被监听的对象

 @param observer 观察者，负责处理监听事件的对象
 @param keyPath 要监听的属性
 @param options 观察的选项 (观察新，旧，原始值 也可以都观察)
 @param context 上下文 用于传递数据，可以利用上下文区分不同的监听
 */
//- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
/**
 当监控的某个属性的值改变了就会调用

 @param keyPath 监听的属性名
 @param object 属性所属的对象
 @param change 属性的修改情况（属性原来的值`oldValue`、属性最新的值`newValue`）
 @param context 传递的上下文数据，与监听的时候传递的一致，可以利用上下文区分不同的监听
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"father.name = %@",self.fa.name);
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
