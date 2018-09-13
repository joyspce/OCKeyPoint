//
//  BgDownloadManager.h
//  NSURLSession
//
//  Created by JiWuChao on 2018/9/13.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BgDownloadManager : NSObject <NSURLSessionDelegate>

+ (instancetype)shared;

- (void)startWithAds:(NSString *)ads;


@end
