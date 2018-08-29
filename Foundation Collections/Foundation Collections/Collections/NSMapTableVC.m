//
//  NSMapTableVC.m
//  Foundation Collections
//
//  Created by JiWuChao on 2018/8/28.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "NSMapTableVC.h"

@interface NSMapTableVC ()

@end

@implementation NSMapTableVC

/*
    NSMapTable

    NSMapTable 是 NSDictionary 的通用版本。和 NSDictionary / NSMutableDictionary 不同的是，NSMapTable 具有下面这些特性：
 
    NSDictionary / NSMutableDictionary 对键进行拷贝，对值持有强引用。
    NSMapTable 是可变的，没有不可变的对应版本。
    NSMapTable 可以持有键和值的弱引用，当键或者值当中的一个被释放时，整个这一项就会被移除掉。
    NSMapTable 可以在加入成员时进行 copy 操作。
    NSMapTable 可以存储任意的指针，通过指针来进行相等性和散列检查。
 注意： NSMapTable 专注于强引用和弱引用，意外着 Swift 中流行的值类型是不适用的，只能用于引用类型。
 

 
 */



- (void)viewDidLoad {
    [super viewDidLoad];
    NSMapTable *map = [[NSMapTable alloc] initWithKeyOptions:NSPointerFunctionsObjectPersonality valueOptions:NSPointerFunctionsStrongMemory capacity:10];
    
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
