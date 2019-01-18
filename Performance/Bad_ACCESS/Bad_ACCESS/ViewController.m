//
//  ViewController.m
//  Bad_ACCESS
//
//  Created by JiWuChao on 2019/1/17.
//  Copyright © 2019 JiWuChao. All rights reserved.
//

#import "ViewController.h"

static NSMutableArray*array;

@interface ViewController ()

@end

@implementation ViewController



-(void)viewDidLoad
{
    [super viewDidLoad];
    array= [[NSMutableArray alloc]initWithCapacity:5];
    array = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [array addObject:@"Hello"];//使用释放掉的数组
}
@end
