//
//  DownloadTaskViewController.m
//  NSURLSession
//
//  Created by JiWuChao on 2018/9/10.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "DownloadTaskViewController.h"

@interface DownloadTaskViewController ()<NSURLSessionDelegate>

@property (nonatomic, strong)NSURLSessionDownloadTask *download;

@property (nonatomic, strong) NSData *resumeData;

@property (nonatomic, strong) NSURLSession *session;

@end

@implementation DownloadTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.download = [self.session downloadTaskWithURL:[NSURL URLWithString:@"http://he.yinyuetai.com/uploads/videos/common/8AE4015CA6F6B544282B29F4C1DC0C0A.mp4"]];
    
    //对于一个通过downloadTaskWithResumeData:创建的下载任务, session会调用代理的URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes:方法.

    //    self.download = [session downloadTaskWithResumeData:<#(nonnull NSData *)#>];
//    self.download = [session downloadTaskWithResumeData:<#(nonnull NSData *)#> completionHandler:<#^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error)completionHandler#>];
    
}


- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}


- (IBAction)start:(id)sender {
    [self.download resume];
}

- (IBAction)pause:(id)sender {
    [self.download suspend];
//    [self.download cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
//        self.resumeData = resumeData;
//    }];
}

- (IBAction)restart:(id)sender {
    self.download = nil;
    self.download = [self.session downloadTaskWithResumeData:self.resumeData];
    [self.download resume];
}

- (IBAction)cancle:(id)sender {
//    [self.download cancel];
    [self.download cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
    }];
}



#pragma mark - NSURLSessionDelegate

/* The last message a session receives.  A session will only become
 * invalid because of a systemic error or when it has been
 * explicitly invalidated, in which case the error parameter will be nil.
 */
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    NSLog(@"%s",__func__);
}

/*
 这是所有task都必须经历的一个过程. 当一个服务器请求身份验证或TLS握手期间需要提供证书的话,
 URLSession会调用他的代理方法URLSession:didReceiveChallenge:completionHandler:去处理., 另外, 如果连接途中收到服务器返回需要身份认证的response, 也会调用该代理方法.
 */
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    NSLog(@"%s",__func__);
}


- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSLog(@"%s",__func__);
}

#pragma mark - NSURLSessionTaskDelegate


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willBeginDelayedRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLSessionDelayedRequestDisposition disposition, NSURLRequest * _Nullable newRequest))completionHandler {
    NSLog(@"%s",__func__);
}

/*
 * Sent when a task cannot start the network loading process because the current
 * network connectivity is not available or sufficient for the task's request.
 *
 * This delegate will be called at most one time per task, and is only called if
 * the waitsForConnectivity property in the NSURLSessionConfiguration has been
 * set to YES.
 *
 * This delegate callback will never be called for background sessions, because
 * the waitForConnectivity property is ignored by those sessions.
 */
- (void)URLSession:(NSURLSession *)session taskIsWaitingForConnectivity:(NSURLSessionTask *)task  {
    NSLog(@"%s",__func__);
}

/*
 这也是所有task都有可能经历的一个过程, 如果response是HTTP重定位, session会调用代理的URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:方法.
 这里需要调用completionHandler告诉session是否允许重定位, 或者重定位到另一个URL, 或者传nil表示重定位的响应body有效并返回. 如果代理没有实现该方法, 则允许重定位直到达到最大重定位次数.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    NSLog(@"%s",__func__);
    completionHandler(request);
}

/* The task has received a request specific authentication challenge.
 * If this delegate is not implemented, the session specific authentication challenge
 * will *NOT* be called and the behavior will be the same as using the default handling
 * disposition.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    NSLog(@"%s",__func__);
}

/* Sent if a task requires a new, unopened body stream.  This may be
 * necessary when authentication has failed for any request that
 * involves a body stream.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * _Nullable bodyStream))completionHandler {
    NSLog(@"%s",__func__);
}

/* Sent periodically to notify the delegate of upload progress.  This
 * information is also available as properties of the task.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    NSLog(@"%s",__func__);
}

/*
 * Sent when complete statistics information has been collected for the task.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
    NSLog(@"metrics -> %@",metrics);
}

/*
 清求出错的时候调用
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    NSLog(@"downloadTask 结束 --- error:%@",error);
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
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
    NSLog(@"下载完成 %@",[location absoluteString]);
    
}

//以下为可选方法
/*
 在服务器传输数据给客户端期间, 调用此方法给用户传数据
    1 当用户暂停下载时, 调用cancelByProducingResumeData:给用户传已下好的数据.
    2 如果用户想要恢复下载, 把刚刚的resumeData以参数的形式传给- (NSURLSessionDownloadTask *)downloadTaskWithResumeData:(NSData *)resumeData;方法创建新的task继续下载
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten  totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    double progress = (double)totalBytesWritten / (double)totalBytesExpectedToWrite;
    NSLog(@"下载中 - %.0f%%", progress * 100);
}

/*
 
 对于一个通过 downloadTaskWithResumeData: 创建的下载任务, session会调用代理的URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes:方法.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    // 重新下载时调用这个方法
    NSLog(@"重新下载--");
}








@end
