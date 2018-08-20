//
//  ViewController.m
//  runtime--Swizzling
//
//  Created by JiWuChao on 2018/8/13.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "UIViewController+Swizzling.h"

#import "UIViewController+SwizzlingMethodThird.h"

#import "Student.h"

#import "Person.h"

#import <objc/runtime.h>

@interface ViewController ()

@end

/*
    Swizzling 方式一共有三种
    1 第一种在本 ViewController
    2 第二种在 UIViewController+Swizzling
    3 第三种在 UIViewController+SwizzlingMethodThird
 */


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //https://www.jianshu.com/p/a6b675f4d073
    //第一swizzing 方法
    Method oriMethod =   class_getInstanceMethod([Person class], @selector(whoImI));
    Method studMethod =   class_getInstanceMethod([Student class], @selector(myIdentity));
    method_exchangeImplementations(oriMethod, studMethod);
    
    Person *person = [[Person alloc] init];
    [person whoImI]; //方法已经被 student 的方法替换
    
    NSLog(@"原方法名: %s",__func__);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
