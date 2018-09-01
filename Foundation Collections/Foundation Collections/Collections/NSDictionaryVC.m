//
//  NSDictionaryVC.m
//  Foundation Collections
//
//  Created by JiWuChao on 2018/8/28.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "NSDictionaryVC.h"

@interface NSDictionaryVC ()



@end

@implementation NSDictionaryVC


/*
 一个字典存储任意的对象键值对。 由于历史原因，初始化方法 [NSDictionary dictionaryWithObjectsAndKeys:object, key, nil] 使用了相反的值到键的顺序，而新的快捷语法则从 key 开始，@{key : value, ...}。
 
 NSDictionary 中的键是被拷贝的并且需要是不变的。如果在一个键在被用于在字典中放入一个值后被改变的话，那么这个值就会变得无法获取了。一个有趣的细节是，在 NSDictionary 中键是被 copy 的，但是在使用一个 toll-free 桥接的 CFDictionary 时却只会被 retain。CoreFoundation 类没有通用的拷贝对象的方法，因此这时拷贝是不可能的(*)。这只适用于你使用 CFDictionarySetValue() 的时候。如果你是通过 setObject:forKey 来使用一个 toll-free 桥接的 CFDictionary 的话，苹果会为其增加额外处理逻辑，使得键被拷贝。但是反过来这个结论则不成立 — 使用已经转换为 CFDictionary 的 NSDictionary 对象，并用对其使用 CFDictionarySetValue() 方法，还是会导致调用回 setObject:forKey 并对键进行拷贝。
 
 (*)其实有一个现成的键的回调函数 kCFCopyStringDictionaryKeyCallBacks 可以拷贝字符串，因为对于 ObjC对象来说， CFStringCreateCopy() 会调用 [NSObject copy]，我们可以巧妙使用这个回调来创建一个能进行键拷贝的 CFDictionary。
 
    -------- NSDictionary 中的键是被拷贝的并且需要是不变的。---------
 
    NSDictionary 对键的copy是深拷贝

 
 
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableDictionary <NSString *,NSArray<NSString *>*> *dic = [[NSMutableDictionary alloc] init];
    NSString *name = @"zhangsan1";
    [dic setObject:@[@"22",@"11"] forKey:name];
    NSLog(@"dic-->%@",dic);
    name = @"zhangsan2";
    NSLog(@"dic-->%@",dic);
    [dic setObject:@[@"22",@"11"] forKey:name];
    NSLog(@"dic-->%@",dic);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
