//
//  EVentDelivery.m
//  touchEvent
//
//  Created by JiWuChao on 2018/12/15.
//  Copyright © 2018 JiWuChao. All rights reserved.
//

#import "EVentDelivery.h"

#import "BlackView.h"

#import "BlueView.h"

#import "RedView.h"

#import "YellowView.h"


@interface EVentDelivery ()

@property (nonatomic,strong) RedView *redView;

@property (nonatomic,strong) YellowView *yealView;

@property (nonatomic,strong) BlueView *blueView;

@property (nonatomic,strong) BlackView *blackView;


@end


@implementation EVentDelivery

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self redView];
        [self blackView];
        [self yealView];
        [self blueView];
    }
    return self;
}


- (RedView *)redView {
    if (!_redView) {
        _redView = [[RedView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        [self addSubview:_redView];
    }
    return _redView;
}

- (BlackView *)blackView {
    if (!_blackView) {
        _blackView = [[BlackView alloc] initWithFrame:CGRectMake(10, 10, 150, 150)];
        [self addSubview:_blackView];
    }
    return _blackView;
}

- (YellowView *)yealView {
    
    if (!_yealView) {
        _yealView = [[YellowView alloc] initWithFrame:CGRectMake(20, 20, 100, 140)];
        [self addSubview:_yealView];
    }
    return _yealView;
}

- (BlueView *)blueView {
    if (!_blueView) {
        _blueView = [[BlueView alloc] initWithFrame:CGRectMake(30, 30, 90, 90)];
        [self.yealView addSubview:_blueView];
    }
    return _blueView;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"开始触摸 EVentDelivery view");
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"结束触摸 EVentDelivery view");
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"正在触摸 EVentDelivery view");
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"取消触摸 EVentDelivery view");
}



@end
