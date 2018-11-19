//
//  LZWebLoadProgress.h
//  webview
//
//  Created by JiWuChao on 2018/11/19.
//  Copyright © 2018 JiWuChao. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import <UIKit/UIKit.h>

@interface LZWebLoadProgress : CAShapeLayer

- (instancetype)initWithFrame:(CGRect)frame withColor:(UIColor *)color;

@property (nonatomic, strong) UIColor *progressColor;

- (void)startLoad;

- (void)endLoad;


@end

