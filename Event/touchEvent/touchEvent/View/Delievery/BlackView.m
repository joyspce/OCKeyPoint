//
//  BlackView.m
//  touchEvent
//
//  Created by JiWuChao on 2018/12/15.
//  Copyright © 2018 JiWuChao. All rights reserved.
//

#import "BlackView.h"

@implementation BlackView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
        NSLog(@"开始触摸 黑色view");
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"结束触摸 黑色view");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"正在触摸 黑色view");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"取消触摸 黑色 view");
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"黑色 hitTest");
    return [super hitTest:point withEvent:event];
}

@end
