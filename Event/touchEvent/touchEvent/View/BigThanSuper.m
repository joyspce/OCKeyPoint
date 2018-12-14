//
//  BigThanSuper.m
//  touchEvent
//
//  Created by JiWuChao on 2018/12/15.
//  Copyright © 2018 JiWuChao. All rights reserved.
//

#import "BigThanSuper.h"

@interface BigThanSuper ()

@property (nonatomic,strong) UIButton *btn;

@end

/*
    超出父视图响应的问题解决方案
 
 
 */

@implementation BigThanSuper

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        [self btn];
    }
    return self;
}

- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 150, 40)];
        [_btn setTitle:@"点我" forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        [_btn setBackgroundColor:[UIColor grayColor]];
        [self addSubview:_btn];
    }
    return _btn;
}


- (void)clickBtn {
    
    NSLog(@"点击了superView view 上的 btn");
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"开始触摸 superview view");
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"结束触摸 superview view");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"正在触摸 superview view");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"取消触摸 superview view");
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"superView hitTest");
    // 判断在该点上有没有响应的子视图
    UIView *superv = [super hitTest:point withEvent:event];
    if (superv == nil) {// g如果没有则判断这个点在在 btn 的范围内
        CGPoint newPoint = [self.btn convertPoint:point fromView:self];
        // 判断触摸点是否在button上 如果在 则返回 btn
        if (CGRectContainsPoint(self.btn.bounds, newPoint)) {
            superv = self.btn;
        }
    }
    return superv;
}



@end
