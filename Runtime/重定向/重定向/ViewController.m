//
//  ViewController.m
//  重定向
//
//  Created by JiWuChao on 2018/8/9.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import <objc/runtime.h>

#import "Person.h"

#import "Student.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Class people = object_getClass([Person class]);
    Class student = object_getClass([Student class]);
    ////源方法的SEL和Method
    SEL peoSel = @selector(whoImI);
    Method oriMethod =   class_getInstanceMethod(people, peoSel);
    ////交换方法的SEL和Method

    SEL studSel = @selector(myIdentity);
    Method studMethod =   class_getInstanceMethod(people, studSel);
    ////先尝试給源方法添加实现，这里是为了避免源方法没有实现的情况
    BOOL addSuccess = class_addMethod(people, peoSel, method_getImplementation(studMethod), method_getTypeEncoding(studMethod));
    
    if (addSuccess) {
        // 添加成功：将源方法的实现替换到交换方法的实现

        class_replaceMethod(student, studSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        //添加失败：说明源方法已经有实现，直接将两个方法的实现交换即

        method_exchangeImplementations(oriMethod, studMethod);
    }
    
    Person *p = [[Person alloc] init];
    
    [p whoImI];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
