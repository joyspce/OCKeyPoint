//
//  TouchView.m
//  touchEvent
//
//  Created by JiWuChao on 2018/12/15.
//  Copyright © 2018 JiWuChao. All rights reserved.
//

#import "TouchView.h"

@implementation TouchView


/*
 
 UITouch的属性:
 ----------------------------------------------------
 
 触摸产生时所处的窗口
 @property(nonatomic,readonly,retain) UIWindow *window;
 
 触摸产生时所处的视图
 @property(nonatomic,readonly,retain) UIView *view
 ;
 
 短时间内点按屏幕的次数，可以根据tapCount判断单击、双击或更多的点击
 @property(nonatomic,readonly) NSUInteger tapCount;
 
 记录了触摸事件产生或变化时的时间，单位是秒
 @property(nonatomic,readonly) NSTimeInterval timestamp;
 
 当前触摸事件所处的状态
 @property(nonatomic,readonly) UITouchPhase phase;
 
 
 
 
 
 UITouch的方法:
 ----------------------------------------------
 
 (CGPoint)locationInView:(UIView *)view;
 // 返回值表示触摸在view上的位置
 // 这里返回的位置是针对view的坐标系的（以view的左上角为原点(0, 0)）
 // 调用时传入的view参数为nil的话，返回的是触摸点在UIWindow的位置
 
 (CGPoint)previousLocationInView:(UIView *)view;
 // 该方法记录了前一个触摸点的位置
 
 
 */


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//       NSLog(@"触摸Began event = %@ touches = %@",event,touches);
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"触摸end event = %@ touches = %@",event,touches);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    NSLog(@"触摸Moved event = %@ touches = %@",event,touches);
    
    
    // 想让控件随着手指移动而移动,监听手指移动
    // 获取UITouch对象
    UITouch *touch = [touches anyObject];
    // 获取当前点的位置
    CGPoint curP = [touch locationInView:self];
    // 获取上一个点的位置
    CGPoint preP = [touch previousLocationInView:self];
    // 获取它们x轴的偏移量,每次都是相对上一次
    CGFloat offsetX = curP.x - preP.x;
    // 获取y轴的偏移量
    CGFloat offsetY = curP.y - preP.y;
    // 修改控件的形变或者frame,center,就可以控制控件的位置
    // 形变也是相对上一次形变(平移)
    // CGAffineTransformMakeTranslation:会把之前形变给清空,重新开始设置形变参数
    // make:相对于最原始的位置形变
    // CGAffineTransform t:相对这个t的形变的基础上再去形变
    // 如果相对哪个形变再次形变,就传入它的形变
    self.transform = CGAffineTransformTranslate(self.transform, offsetX, offsetY);

}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"触摸取消 event = %@",event );
}


@end
