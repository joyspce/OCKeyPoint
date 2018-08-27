//
//  ViewController.m
//  FBKVOController
//
//  Created by JiWuChao on 2018/8/27.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "PushViewController.h"

@interface ViewController ()



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}
- (IBAction)pushAction:(id)sender {
    PushViewController *push = [[PushViewController alloc] init];
    [self.navigationController pushViewController:push animated:true];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
