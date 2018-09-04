//
//  ViewController.m
//  KVC
//
//  Created by JiWuChao on 2018/9/3.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "Person.h"

@interface ViewController ()

@end

@implementation ViewController

/*
 
 
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    [self findKeySetValue];
    
}


/*
 
 1 程序优先调用set<Key>:属性值方法，代码通过setter方法完
 成设置。注意，这里的<key>是指成员变量名，
 首字母大小写要符合KVC的命名规则，下同
 
 2 如果没有找到setName：方法，KVC机制会检查+ (BOOL)accessInstanceVariablesDirectly
 方法有没有返回YES
 ，默认该方法会返回YES，如果你重写了该方法让其返回NO的话，那么在这一步KVC会执行setValue：forUndefinedKey：方法，不过一
 般开发者不会这么做。所以KVC机制会搜索该类里面有没有
 名为_<key>的成员变量，无论该变量是在类接口处定义，
 还是在类实现处定义，也无论用了什么样的访问修饰符，
 只在存在以_<key>命名的变量，KVC都可以对该成员变量赋值。
 
 3 如果该类即没有set<key>：方法，也没有_<key>成员变量，
 KVC机制会搜索_is<Key>的成员变量。
 和上面一样，如果该类即没有set<Key>：方法，也没有_<key>和_is<Key>成员变量，
 KVC机制再会继续搜索<key>和is<Key>的成员变量。
 再给它们赋值。
 
 4 如果上面列出的方法或者成员变量都不存在，系统将会执行该
 对象的setValue：forUndefinedKey：方法，默认是抛出异常。

 
 
 */

//设值
- (void)findKeySetValue {
    Person *p = [[Person alloc] init];
    [p setValue:@"newname" forKey:@"name"];
    
//    NSString *name1 = [p valueForKey:@"_name"];
//    NSLog(@"_name = %@",name1);
    NSString *name2 = [p valueForKey:@"name"];
    NSLog(@"name == %@",name2);
    
//    NSString *name3 = [p valueForKey:@"_isName"];
//    NSLog(@"_isName = %@",name3);
//    NSString *name4 = [p valueForKey:@"isName"];
//    NSLog(@"isName == %@",name4);
    
}


/*
 
 当调用valueForKey：@”name“的代码时，KVC对key的搜索方式不同于setValue：属性值 forKey：@”name“，其搜索方式如下：
 

 
 取值

 
 */

- (void)findKeyGetKey {
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
