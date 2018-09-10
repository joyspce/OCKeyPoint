//
//  DownloadTaskViewController.m
//  NSURLSession
//
//  Created by JiWuChao on 2018/9/10.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "DownloadTaskViewController.h"

@interface DownloadTaskViewController ()<NSURLSessionDelegate>

@end

@implementation DownloadTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - NSURLSessionDownloadDelegate

/*
 1 对于一个通过downloadTaskWithResumeData:创建的下载任务, session会调用代理的URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes:方法.
 2 在服务器传输数据给客户端期间, 调用URLSession:downloadTask:didWriteData:totalBytesWritten:
 totalBytesExpectedToWrite:给用户传数据
 2.1 当用户暂停下载时, 调用cancelByProducingResumeData:给用户传已下好的数据.
 2.2 如果用户想要恢复下载, 把刚刚的resumeData以参数的形式传给downloadTaskWithResumeData:方法创建新的task继续下载.
 3 如果download task成功完成了, 调用URLSession:downloadTask:didFinishDownloadingToURL:把临时文件的URL路径给你. 此时你应该在该代理方法返回以前读取他的数据或者把文件持久化.
 
 
 */

//如果download task成功完成了, 调用此代理方法把临时文件的URL路径给你.
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    
}

//以下为可选方法
/*
 在服务器传输数据给客户端期间, 调用此方法给用户传数据
 1 当用户暂停下载时, 调用cancelByProducingResumeData:给用户传已下好的数据.
 //- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData;
 2 如果用户想要恢复下载, 把刚刚的resumeData以参数的形式传给(void)cancelByProducingResumeData:(void (^)(NSData * _Nullable resumeData))completionHandler 方法创建新的task继续下载
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten  totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    
}

/*
 
 对于一个通过 downloadTaskWithResumeData: 创建的下载任务, session会调用代理的URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes:方法.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    // 重新下载时调用这个方法
}

@end
