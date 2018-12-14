//
//  ViewController.m
//  touchEvent
//
//  Created by JiWuChao on 2018/12/15.
//  Copyright © 2018 JiWuChao. All rights reserved.
//

#import "ViewController.h"

#import "TouchView.h"

@interface ViewController ()

@property (nonatomic,strong) TouchView *touch;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.touch = [[TouchView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    self.touch.backgroundColor = UIColor.redColor;
    [self.view addSubview:self.touch];
}


@end
