//
//  ForwardMessage.m
//  runtime 消息转发2--快速转发
//
//  Created by JiWuChao on 2018/12/6.
//  Copyright © 2018 JiWuChao. All rights reserved.
//

#import "ForwardMessage.h"
#import <objc/runtime.h>

@implementation ForwardMessage

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    NSLog(@"1--name:%s",__func__);
    return NO;
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSLog(@"2--name:%s",__func__);
    return nil;
}
// signature 签名
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSLog(@"3--name:%s",__func__);
    NSString *sel = NSStringFromSelector(aSelector);
    //手动生成签名
    if ([sel isEqualToString:@"forward"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }else {
        return [super methodSignatureForSelector:aSelector];
    }
    // 注意 ：如果这一步e没有生成签名 即此步返回为 nil 则不会执行第四步 直接 crash ，但只要这一步返回签名 即使第四步什么都没做 也不会crash
   
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSLog(@"4--name:%s",__func__);
}

 
@end
