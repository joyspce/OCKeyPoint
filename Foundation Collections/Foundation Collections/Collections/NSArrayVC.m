//
//  NSArrayVC.m
//  Foundation Collections
//
//  Created by JiWuChao on 2018/8/28.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "NSArrayVC.h"

#import "TTTRandomizedEnumerator.h"

@interface NSArrayVC ()

@end

@implementation NSArrayVC


/*
    NSArray 作为一个存储对象的有序集合，可能是被使用最多的集合类。这也是为什么它有自己的比原来的 [NSArray arrayWithObjects:..., nil] 简短得多的快速语法糖符号 @[...]。 NSArray 实现了 objectAtIndexedSubscript:，因为我们可以使用类 C 的语法 array[0] 来代替原来的 [array objectAtIndex:0]。
 
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *testArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    //倒叙
    NSLog(@"倒叙:%@",testArray.reverseObjectEnumerator.allObjects);
//    //乱序
    NSArray *rundom = testArray.randomizedObjectEnumerator.allObjects;
    NSLog(@"乱序:%@",rundom);

    
    /* 排序：
     
     函数指针的排序方法:
     
     - (NSData *)sortedArrayHint;
     - (NSArray *)sortedArrayUsingFunction:(NSInteger (*)(id, id, void *))comparator
     context:(void *)context;
     - (NSArray *)sortedArrayUsingFunction:(NSInteger (*)(id, id, void *))comparator
     context:(void *)context hint:(NSData *)hint;
     
     
     基于block的排序方法:
     
     - (NSArray *)sortedArrayUsingComparator:(NSComparator)cmptr;
     - (NSArray *)sortedArrayWithOptions:(NSSortOptions)opts
     usingComparator:(NSComparator)cmptr;
     
     
     */
    
    // 字符串排序
    NSArray *sortArray = [testArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSLog(@"%@",sortArray);
    
    
    //数字排序
    NSArray *numbers = @[@9, @5, @11, @3, @1];
    NSArray *sortedNumbers = [numbers sortedArrayUsingSelector:@selector(compare:)];
    
    NSLog(@"数字排序:%@",sortedNumbers);
    /*
     (
         1,
         3,
         5,
         9,
         11
     )
     
     */
    /*
     查找 二分查找 待查找的源数组必须有序的
     typedef NS_OPTIONS(NSUInteger, NSBinarySearchingOptions) {
         NSBinarySearchingFirstEqual = (1UL << 8),  如果数组中有多个一样的值时 取第一个相等的
         NSBinarySearchingLastEqual = (1UL << 9), 如果数组中有多个一样的值时 取最后一个相等的
         NSBinarySearchingInsertionIndex = (1UL << 10), 你可以获得正确的插入索引，以确保在插入元素后仍然可以保证数组的顺序。
     };
     
     */
    
    NSInteger index = [sortedNumbers indexOfObject:@5 inSortedRange:NSMakeRange(0, numbers.count) options:NSBinarySearchingInsertionIndex usingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSLog(@"查找 index =  %ld",index);
    // 查找 index =  2
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
