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
    
   
    
    
    
    /*
        获取协议中的属性
     */
    
//    id studProtocol = objc_getProtocol("StudentProtocol");
//
//    unsigned int protocolCount = 0;
//    objc_property_t *protocolPropertyList = protocol_copyPropertyList(studProtocol, &protocolCount);
//
//    for (NSInteger i = 0; i < protocolCount; i++) {
//        //property_getName(objc_property_t _Nonnull property)  获取属性名称
//        const char *propertyName = property_getName(protocolPropertyList[i]);
//        NSLog(@"studProtocol---->%@", [NSString stringWithUTF8String:propertyName]);
//    }
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
 获取类中的属性
 */
- (void)getClassMethodList {
    id student = objc_getClass("Student");
    unsigned int outCount = 0;
//    Method *prppertiesList = class_copyMethodList(student, &outCount);
//    for (NSInteger i = 0; i < outCount ; i++) {
//        
//    }
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
