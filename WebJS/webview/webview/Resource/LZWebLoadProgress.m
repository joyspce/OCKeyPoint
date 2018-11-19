//
//  LZWebLoadProgress.m
//  webview
//
//  Created by JiWuChao on 2018/11/19.
//  Copyright © 2018 JiWuChao. All rights reserved.
//

#import "LZWebLoadProgress.h"

@interface LZWebLoadProgress ()

@property (nonatomic,strong) UIColor *bgColor;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGFloat stepWidth;

@property (nonatomic, assign) CGFloat lineHeight;


@end

static NSTimeInterval const progressInterval = 0.001;

@implementation LZWebLoadProgress

- (instancetype)initWithFrame:(CGRect)frame withColor:(UIColor *)color {
    if (self = [super init]) {
        self.frame = frame;
        self.stepWidth = 0.001;
        self.lineHeight = frame.size.height;
        self.progressColor = color;
        [self initPathWithLineWidth:self.lineHeight];
    }
    return self;
}

- (void)initPathWithLineWidth:(CGFloat)width {
    self.lineWidth = width;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, width)];
    [path addLineToPoint:CGPointMake([UIScreen mainScreen].bounds.size.width, width)];
    self.path = path.CGPath;
    self.strokeEnd = 0.0;
}

- (void)setProgressColor:(UIColor *)progressColor {
    _progressColor = progressColor;
    self.strokeColor = _progressColor.CGColor;
}

#pragma mark - Public

- (void)startLoad {
    [self invalidateTimer];
    self.hidden = NO;
    self.timer = [NSTimer timerWithTimeInterval:progressInterval
                                         target:self
                                       selector:@selector(progressChanged)
                                       userInfo:nil
                                        repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer
                                 forMode:NSRunLoopCommonModes];
}

- (void)endLoad {
    [self invalidateTimer];
    self.strokeEnd = 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        self.strokeEnd = 0.0;
    });
}





#pragma mark - Private

- (void)invalidateTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)progressChanged {
    self.strokeEnd += self.stepWidth;
    if (self.strokeEnd > 0.7) {
        self.stepWidth = 0.00001;
    }
    if (self.strokeEnd > 0.9) {
        _stepWidth = 0;
    }
}


@end
