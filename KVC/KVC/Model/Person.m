//
//  Person.m
//  KVC
//
//  Created by JiWuChao on 2018/9/4.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "Person.h"

@interface Person() {
    NSString *toSetName;
    //5
    NSString *isName;
    //4
//    NSString *name;
    //2
//    NSString *_name;
    //3
//    NSString *_isName;
}



@end


@implementation Person

//1
//- (void)setName:(NSString*)name{
//     toSetName = name;
// }

//- (NSString*)getName{
//    return _name;
//}


+ (BOOL)accessInstanceVariablesDirectly {
    
    return YES;
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"key== %@ 不存在",key);
    NSLog(@"%s",__func__);
    return nil;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
   NSLog(@"key== %@ 不存在",key);
    NSLog(@"%s",__func__);
}





@end
