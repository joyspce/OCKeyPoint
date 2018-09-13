//
//  AppDelegate.m
//  NSURLSession
//
//  Created by JiWuChao on 2018/9/7.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "AppDelegate.h"

#import "BgDownloadManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [BgDownloadManager shared];
    return YES;
}




/**
 后台下载处理

 @param application <#application description#>
 @param identifier <#identifier description#>
 @param completionHandler <#completionHandler description#>
 */
- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)(void))completionHandler {
    
    
    NSLog(@"identifier: %@",identifier);
}



@end
