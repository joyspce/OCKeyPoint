//
//  KVCContainerModel.h
//  KVC
//
//  Created by JiWuChao on 2018/9/5.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KVCContainerModel : NSObject

@property (nonatomic, copy) NSArray *array;

@property (nonatomic, strong) NSMutableArray *mArray;

@property (nonatomic, strong) NSMutableArray *errorArray;

- (void)addObj;

- (void)addObjObserver;

- (void)removeObj;

- (void)addErrorArray;

@end
