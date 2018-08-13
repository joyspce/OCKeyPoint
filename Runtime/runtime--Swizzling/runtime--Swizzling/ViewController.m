//
//  ViewController.m
//  runtime--Swizzling
//
//  Created by JiWuChao on 2018/8/13.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "UIViewController+Swizzling.h"

#import "Student.h"

#import "Person.h"

#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //第一swizzing 方法
    Method oriMethod =   class_getInstanceMethod([Person class], @selector(whoImI));
    Method studMethod =   class_getInstanceMethod([Student class], @selector(myIdentity));
    method_exchangeImplementations(oriMethod, studMethod);
    
    Person *person = [[Person alloc] init];
    [person whoImI]; //方法已经被 student 的方法替换
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
