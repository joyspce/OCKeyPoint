//
//  ViewController.m
//  KVC
//
//  Created by JiWuChao on 2018/9/3.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "Person.h"

#import "TimesModel.h"

#import "KeyPathModel.h"

#import "KVCSetNilValueModel.h"

@interface ViewController ()

@end

@implementation ViewController

/*
 
 
 */


- (void)viewDidLoad {
    [super viewDidLoad];
//    [self findKeySetValue];
//    [self findKeyGetKey];
//    [self keyPathTest];
    [self setNilValueTest];
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
 
 1 首先按get<Key>,<key>,is<Key>的顺序方法查找getter方法
 ，找到的话会直接调用。如果是BOOL或者Int等值类型，会将其包装成一个NSNumber对象。
 
 2 如果上面的getter没有找到，KVC则会查找countOf<Key>,objectIn<Key>AtIndex或<Key>AtIndexes格式的方法。
 如果countOf<Key>方法和另外两个方法中的一个被找到，
 那么就会返回一个可以响应NSArray所�有方法的代理集合(它是NSKeyValueArray，是NSArray的子类)，
 调用这个代理集合的方法，或者说给这个代理集合发送属于
 NSArray的方法，就会以countOf<Key>,objectIn<Key>AtIndex�或<Key>AtIndexes这几个方法组合的形式调用。
 还有一个可选的get<Key>:range:方法。所以你想重新定义KVC
 的一些功能，你可以添加这些方法
 ，需要注意的是你的方法名要符合KVC的标准命名方法，包括方法签名。
 
 3 如果上面的方法没有找到，那么会同时查找countOf<Key>，enumeratorOf<Key>,memberOf<Key>格式的方法。如果这三个方法
 都找到，那么就返回一个可以响应NSSet所的方法的代理集合，
 和上面一样，给这个代理集合发NSSet的消息，
 就会以countOf<Key>，enumeratorOf<Key>,memberOf<Key>组合的形式调用。

 
 取值

 
 */

- (void)findKeyGetKey {
    TimesModel *model = [[TimesModel alloc] init];
    id nums = [model valueForKey:@"num"];
    NSLog(@"num = %@",nums);
    
    id numbers = [model valueForKey:@"numbers"];
    NSLog(@"NSStringFromClass([numbers class]) = %@",NSStringFromClass([numbers class]));
//    NSLog(@"%@",numbers);
//    NSLog(@"0:%@     1:%@     2:%@     3:%@",numbers[0],numbers[1],numbers[2],numbers[3]);
    
    
    [model incrementCount];                                                                            //count加1
    NSLog(@"%lu",(unsigned long)[numbers count]);                                                         //打印出1
    [model incrementCount];                                                                            //count再加1
    NSLog(@"%lu",(unsigned long)[numbers count]);                                                         //打印出2
    
    [model setValue:@"newName" forKey:@"arrName"];
    NSString* name = [model valueForKey:@"arrName"];
    NSLog(@"name==%@",name);

    
}


- (void)keyPathTest {
    KeyPathModel *model = [[KeyPathModel alloc] init];
    KeyPath *keyPath = [[KeyPath alloc] init];
    keyPath.testKeyPath = @"test";
    model.keyPath = keyPath;
    
    NSString *keypath1 = model.keyPath.testKeyPath;
    NSString *keypath2 = [model valueForKeyPath:@"keyPath.testKeyPath"];
    NSLog(@"keypath1 = %@",keypath1);
    NSLog(@"keypath2 = %@",keypath2);

    [model setValue:@"change" forKeyPath:@"keyPath.testKeyPath"];
    NSString *keypath3 = model.keyPath.testKeyPath;
    NSString *keypath4 = [model valueForKeyPath:@"keyPath.testKeyPath"];
    NSLog(@"keypath3 = %@",keypath3);
    NSLog(@"keypath4 = %@",keypath4);
}

- (void)setNilValueTest {
    
    KVCSetNilValueModel *model = [[KVCSetNilValueModel alloc] init];
    [model setValue:nil forKey:@"name"]; // 引用类型不会调用 - (void)setNilValueForKey:(NSString *)key
//    [model setValue:nil forKey:@"age"]; // 值类型会调用  - (void)setNilValueForKey:(NSString *)key 因为值类型不可能为 nil 所以抛出异常 此时如果不重写 此方法则会发生崩溃
    NSLog(@"name = %@",[model valueForKey:@"name"]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
