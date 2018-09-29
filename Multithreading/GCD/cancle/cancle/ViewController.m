//
//  ViewController.m
//  cancle
//
//  Created by JiWuChao on 2018/9/29.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "SpacemanBlocks.h"

@interface ViewController ()

@property (nonatomic,copy)SMDelayedBlockHandle block;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.block =  perform_block_after_delay(5, ^{
        NSLog(@"11111");
    });
    NSLog(@"211113");
    cancel_delayed_block(self.block);
    
}


@end
