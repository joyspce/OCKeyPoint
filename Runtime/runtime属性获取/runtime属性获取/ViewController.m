//
//  ViewController.m
//  runtime属性获取
//
//  Created by JiWuChao on 2018/8/8.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import <objc/runtime.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self getClassPropertyList];
//    [self getClassMethodList];
//    [self getClassIvarList];
    
    [self  getClassProtocolList];
}
/*
 获取类中的属性
 */

- (void)getClassPropertyList{
 
    id studentClass = objc_getClass("Student");
    unsigned int outCount = 0;
    //Returns an array of properties declared by a protocol
    objc_property_t *propertiesList = class_copyPropertyList(studentClass, &outCount);
    for (NSInteger i = 0; i < outCount; i++) {
        //property_getName(objc_property_t _Nonnull property)  获取属性名称
        const char *propertyName = property_getName(propertiesList[i]);
        NSLog(@"property---->%@", [NSString stringWithUTF8String:propertyName]);
    }
    
    /*
     property---->name
     property---->age
     property---->heigh
     */
    
}

/*
 获取类中的方法
 */
- (void)getClassMethodList {
    id student = objc_getClass("Student");
    unsigned int outCount = 0;
    Method *methodList = class_copyMethodList(student, &outCount);
    for (NSInteger i = 0; i < outCount ; i++) {
        Method me = methodList[i];
        NSLog(@"%@", NSStringFromSelector(method_getName(me)));
    }
    
}

/*获取成员变量的方法
 
 */
- (void) getClassIvarList{
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(objc_getClass("Student"), &count);
    for (unsigned int i = 0; i < count; i++) {
        Ivar myIvar = ivarList[i];
        const char *ivarName = ivar_getName(myIvar);
        NSLog(@"Ivar---->%@", [NSString stringWithUTF8String:ivarName]);
    }
    
    /*
     Ivar---->_name
     Ivar---->_age
     Ivar---->_heigh
     */
    
}


/**
 获取类遵循了多少协议
 */
- (void)getClassProtocolList {
    unsigned int count = 0;
    __unsafe_unretained Protocol **protocolList = class_copyProtocolList(objc_getClass("Student"), &count);
    for (unsigned int i = 0; i<count; i++) {
        Protocol *myProtocal = protocolList[i];
        const char *protocolName = protocol_getName(myProtocal);
        NSLog(@"protocol---->%@", [NSString stringWithUTF8String:protocolName]);
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
