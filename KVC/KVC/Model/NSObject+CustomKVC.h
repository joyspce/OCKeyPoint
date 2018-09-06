//
//  NSObject+CustomKVC.h
//  KVC
//
//  Created by JiWuChao on 2018/9/6.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CustomKVC)

- (void)setCtmValue:(id)value forKey:(NSString *)key;
- (id)ctmValueforKey:(NSString *)key;



@end


