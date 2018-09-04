//
//  TimesModel.h
//  KVC
//
//  Created by JiWuChao on 2018/9/4.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimesModel : NSObject

-(void)incrementCount;

- (NSUInteger)countOfNumbers;

-(id)objectInNumbersAtIndex:(NSUInteger)index;


- (NSInteger)countOfNum;

- (id)objectInNumAtIndex:(NSUInteger)index;

- (id)numAtIndexes:(NSUInteger)index;

- (NSUInteger)enumeratorOfNum;

- (id)memberOfNum:(NSUInteger)index;



@end
