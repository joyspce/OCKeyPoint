//
//  NSObject+KVO.h
//  CustomKVO
//
//  Created by JiWuChao on 2018/8/22.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^JWCObserverBlock)(id observerObj,NSString *observerKey,id oldValue,id newValue);


@interface NSObject (KVO)

- (void)jw_addObserver:(NSObject *)observer forKey:(NSString *)key withBlock:(JWCObserverBlock)block;

- (void)jw_removeObserver:(NSObject *) observer forKey:(NSString *)key;


@end
