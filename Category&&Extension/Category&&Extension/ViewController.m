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

#import <objc/runtime.h>

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
 
    ** Category的结构体 ：
 
     typedef struct category_t {
        const char *name;  //类的名字
        classref_t cls;  //类
        struct method_list_t *instanceMethods;  //category中所有给类添加的实例方法的列表
        struct method_list_t *classMethods;  //category中所有添加的类方法的列表
        struct protocol_list_t *protocols;  //category实现的所有协议的列表
        struct property_list_t *instanceProperties;  //category中添加的所有属性
     } category_t;
 
   ** objc_method_list 的结构体
 
     struct objc_method_list {
        struct objc_method_list * _Nullable obsolete             OBJC2_UNAVAILABLE;
        int method_count                                         OBJC2_UNAVAILABLE;
        #ifdef __LP64__
        int space                                                OBJC2_UNAVAILABLE;
        #endif
        //variable length structure
        struct objc_method method_list[1]                        OBJC2_UNAVAILABLE;
     }
 
 
    2.1 是运行期决议的
    2.2 类扩展可以添加实例变量，分类不能添加实例变量（用runtime可以）
    2.3 原因：因为在运行期，对象的内存布局已经确定，如果添加实例变量会破坏类的内部布局，这对编译性语言是灾难性的。
 
 
 3  Category 添加属性
 
    3.1 category 添加属性 不会生成_变量（带下划线的成员变量），也不会生成添加属性的getter和setter方法
    3.1  使用runtime的 关联机制可以动态的为Category中添加的属性 手动setter和getter方法 并在其中做值得关联逻辑
 
 4  分类中添加方方法时原类也有这个方法 这个方法就不调用了，即被category 中的同名方法“替换”掉了
 
    4.1 category的方法没有“完全替换掉”原来类已经有的方法，也就是说如果category和原来类都有methodA，那么category附加完成之后，类的方法列表里会有两个methodA
 
    4.2 category的方法被放到了新方法列表的前面，而原来类的方法被放到了新方法列表的后面，这也就是我们平常所说的category的方法会“覆盖”掉原来类的同名方法，这是因为运行时在查找方法的时候是顺着方法列表的顺序查找的，它只要一找到对应名字的方法，就会停止查找
 
 
5  怎么调用到原来类中被category覆盖掉的方法？
    对于这个问题，我们已经知道category其实并不是完全替换掉原来类的同名方法，只是category在方法列表的前面而已，所以我们只要顺着方法列表找到最后一个对应名字的方法，就可以调用原来类的方法
 
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
    //分类中的方法 “覆盖了”原类中的方法
    [self.father goShoping];
    [self findOriginMethod];
    NSLog(@"Category 添加的属性 = %@ ",self.father.idNumber);
}


/*
 Method 是一个结构题
 
 typedef struct objc_method *Method;
 
 struct objc_method {
    SEL _Nonnull method_name                          //方法的名称
    char * _Nullable method_types                     //方法的类型
    IMP _Nonnull method_imp                           //方法的实现
 }                                                            OBJC2_UNAVAILABLE;
 

 
 
 */


- (void)findOriginMethod {
    Father *fa = [[Father alloc] init];
    Class currentClass = [Father class];
    if (currentClass) {
        unsigned int count;
        Method *methodList = class_copyMethodList(currentClass, &count);
        IMP lastImp = NULL;
        SEL lastSel = NULL;
        for (NSInteger i = 0; i < count ; i++) {
            Method method = methodList[i];
            NSString *methodName = [NSString stringWithCString:sel_getName(method_getName(method)) encoding:NSUTF8StringEncoding];
            if ([methodName isEqualToString:@"goShoping"]) {
                lastImp = method_getImplementation(method);//方法的实现
                lastSel = method_getName(method);//方法的名称
                NSLog(@"type:== %@",[NSString stringWithCString:method_getTypeEncoding(method) encoding:NSUTF8StringEncoding]);
            }
        }
        typedef void (*fn)(id,SEL);
        
        if (lastImp != NULL) {
            fn f = (fn)lastImp;
            f(fa,lastSel);
        }
        free(methodList);
    }
}


@end
