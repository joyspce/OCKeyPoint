//
//  ViewController.m
//  Category&&Extension
//
//  Created by JiWuChao on 2018/8/21.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "Father.h"

#import "Father+Ext.h"

#import "Father+Category.h"

//参考 ：https://tech.meituan.com/DiveIntoCategory.html
@interface ViewController ()

@property (nonatomic,strong) Father *father;

@end

/*
 Extension与Category区别
 
 1  Extension
 
    1.1 在编译器决议，是类的一部分，在编译器和头文件的@interface和实现文件里的@implement一起形成了一个完整的类。
    1.2 伴随着类的产生而产生，也随着类的消失而消失。
    1.3 Extension一般用来隐藏类的私有消息，你必须有一个类的源码才能添加一个类的Extension，所以对于系统一些类，如NSString，就无法添加类扩展
 
 2  Category
 
 Category的结构体 ：
 
 typedef struct category_t {
    const char *name;  //类的名字
    classref_t cls;  //类
    struct method_list_t *instanceMethods;  //category中所有给类添加的实例方法的列表
    struct method_list_t *classMethods;  //category中所有添加的类方法的列表
    struct protocol_list_t *protocols;  //category实现的所有协议的列表
    struct property_list_t *instanceProperties;  //category中添加的所有属性
 } category_t;
 
 
 
    2.1 是运行期决议的
    2.2 类扩展可以添加实例变量，分类不能添加实例变量（用runtime可以）
    2.3 原因：因为在运行期，对象的内存布局已经确定，如果添加实例变量会破坏类的内部布局，这对编译性语言是灾难性的。
 
 
 3 Category 添加属性
 
    3.1 category 添加属性 不会生成_变量（带下划线的成员变量），也不会生成添加属性的getter和setter方法
    3.1  使用runtime的 关联机制可以动态的为Category中添加的属性 手动setter和getter方法 并在其中做值得关联逻辑
 
 
 
 */



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.father = [[Father alloc] init];
    self.father.name = @"张三";
    self.father.www = @"wksksk";//扩展中的属性
    self.father.idNumber = @"2132132132132";
    //扩展中的方法
    [self.father gotoWork];
    //分类中的方法
    [self.father goShoping];
    
    NSLog(@"Category 添加的属性 = %@ ",self.father.idNumber);
}


  


@end
