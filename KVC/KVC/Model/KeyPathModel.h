//
//  KeyPathModel.h
//  KVC
//
//  Created by JiWuChao on 2018/9/5.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KeyPath: NSObject

@property (nonatomic, copy) NSString *testKeyPath;

@end

@interface KeyPathModel : NSObject

@property (nonatomic,copy) NSString *name;

@property (nonatomic, strong) KeyPath *keyPath;


@end
