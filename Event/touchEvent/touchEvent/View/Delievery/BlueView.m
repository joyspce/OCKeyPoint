//
//  BlueView.m
//  touchEvent
//
//  Created by JiWuChao on 2018/12/15.
//  Copyright © 2018 JiWuChao. All rights reserved.
//

#import "BlueView.h"

@interface BlueView ()

@property (nonatomic,strong) UIButton *btn;

@end


@implementation BlueView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        // 1 如果添加 btn 事件则不会处理触摸事件
        [self btn];
        // 2 如果 userInteractionEnabled 关闭则此view 上的任何事件都不会处理
//        self.userInteractionEnabled = false;
        
        // 3 如果添加点击事件 则不会触发 btn 事件 但同时会触发 触摸事件 然后触发点击事件
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        
        [self addGestureRecognizer:ges];
        
        // 4 如果想要处理任何事件都返回某一个 view 则要重写 (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event 方法
        
    }
    return self;
}


- (void)tapAction {
    NSLog(@"tap 事件");
}


- (UIButton *)btn {
    if (!_btn) {
        _btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        [_btn setTitle:@"点我" forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
        [_btn setBackgroundColor:[UIColor grayColor]];
        [self addSubview:_btn];
    }
    return _btn;
}


- (void)clickBtn {
    
    NSLog(@"点击了蓝色 view 上的 btn");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"开始触摸 蓝色view");
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"结束触摸 蓝色view");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"正在触摸 蓝色view");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"取消触摸 蓝色 view");
}

/*
 -(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
 作用
    寻找并返回最合适的view(能够响应事件的那个最合适的view)
 
 拦截事件的处理
 
 正因为hitTest：withEvent：方法可以返回最合适的view，所以可以通过重写hitTest：withEvent：方法，返回指定的view作为最合适的view。
 不管点击哪里，最合适的view都是hitTest：withEvent：方法中返回的那个view。
 通过重写hitTest：withEvent：，就可以拦截事件的传递过程，想让谁处理事件谁就处理事件。
 
  
 
 
 
 */
 

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    NSLog(@"蓝色 hitTest");
    return [super hitTest:point withEvent:event];
}





@end
