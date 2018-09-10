//
//  ViewController.m
//  NSURLSession
//
//  Created by JiWuChao on 2018/9/7.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDelegate>


@property (nonatomic,strong) NSURLSessionTask *task;
// 继承自NSURLSessionTask
@property(nonatomic,strong) NSURLSessionDataTask *dataTask;
// 继承自NSURLSessionTask
@property (nonatomic, strong) NSURLSessionDownloadTask *downloadTask;
// 继承自NSURLSessionDataTask
@property (nonatomic, strong) NSURLSessionUploadTask *uploadTask;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self testAll];
    
    
   
}


- (void)testAll {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
    
    NSURL *url = [NSURL URLWithString:@"http://rankapi.longzhu.com/ranklist/GetWeekRoomIdItemId?bundleId=com.longzhu.tga&roomId=2368600"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url];
//    self.dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        //        NSLog(@"res = %@",response);
//        NSLog(@"11----%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
//        //打印解析后的json数据
//        NSLog(@"22---%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
//
//    }];
    [dataTask resume];

}


#pragma mark - NSURLSessionDelegate

/* The last message a session receives.  A session will only become
 * invalid because of a systemic error or when it has been
 * explicitly invalidated, in which case the error parameter will be nil.
 */
- (void)URLSession:(NSURLSession *)session didBecomeInvalidWithError:(nullable NSError *)error {
    
}

/*
 这是所有task都必须经历的一个过程. 当一个服务器请求身份验证或TLS握手期间需要提供证书的话,
 URLSession会调用他的代理方法URLSession:didReceiveChallenge:completionHandler:去处理., 另外, 如果连接途中收到服务器返回需要身份认证的response, 也会调用该代理方法.
 */
- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
}

/* If an application has received an
 * -application:handleEventsForBackgroundURLSession:completionHandler:
 * message, the session delegate will receive this message to indicate
 * that all messages previously enqueued for this session have been
 * delivered.  At this time it is safe to invoke the previously stored
 * completion handler, or to begin any internal updates that will
 * result in invoking the completion handler.
 */
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    
}

#pragma mark - NSURLSessionTaskDelegate


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willBeginDelayedRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLSessionDelayedRequestDisposition disposition, NSURLRequest * _Nullable newRequest))completionHandler {
    
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
    
}

/*
 这也是所有task都有可能经历的一个过程, 如果response是HTTP重定位, session会调用代理的URLSession:task:willPerformHTTPRedirection:newRequest:completionHandler:方法.
 这里需要调用completionHandler告诉session是否允许重定位, 或者重定位到另一个URL, 或者传nil表示重定位的响应body有效并返回. 如果代理没有实现该方法, 则允许重定位直到达到最大重定位次数.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    
}

/* The task has received a request specific authentication challenge.
 * If this delegate is not implemented, the session specific authentication challenge
 * will *NOT* be called and the behavior will be the same as using the default handling
 * disposition.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * _Nullable credential))completionHandler {
    
}

/* Sent if a task requires a new, unopened body stream.  This may be
 * necessary when authentication has failed for any request that
 * involves a body stream.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream * _Nullable bodyStream))completionHandler {
    
}

/* Sent periodically to notify the delegate of upload progress.  This
 * information is also available as properties of the task.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend {
    
}

/*
 * Sent when complete statistics information has been collected for the task.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics {
    
}

/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    
}






#pragma mark - NSURLSessionDataDelegate

/*
 对于一个data task来说, session会调用代理的
 1 URLSession:dataTask:didReceiveResponse:completionHandler:
 方法, 决定是否将一个data dask转换成download task, 然后调用completion回调继续接收data或下载data.
  1.1 如果你的app选择转换成download task, session会调用代理的
 URLSession:dataTask:didBecomeDownloadTask: 方法并把新的download task对象以方法参数的形式传给你.
 之后代理不会再收到data task的回调而是转为收到download task的回调
 
 2 在服务器传输数据给客户端期间, 代理会周期性地收到URLSession:dataTask:didReceiveData:回调
 
 3 session会调用URLSession:dataTask:willCacheResponse:completionHandler:询问你的app是否允许缓存.
 如果代理不实现这个方法的话, 默认使用session绑定的Configuration的缓存策略.

 
 */


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSLog(@"1-->%@",response);
}

/*
 如果你的app选择转换成download task, session会调用代理的
 URLSession:dataTask:didBecomeDownloadTask: 方法并把新的download task对象以方法参数的形式传给你.
 之后代理不会再收到data task的回调而是转为收到download task的回调
 
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask {
     NSLog(@"2-->%@",dataTask);
}

/*
 * Notification that a data task has become a bidirectional stream
 * task.  No future messages will be sent to the data task.  The newly
 * created streamTask will carry the original request and response as
 * properties.
 *
 * For requests that were pipelined, the stream object will only allow
 * reading, and the object will immediately issue a
 * -URLSession:writeClosedForStream:.  Pipelining can be disabled for
 * all requests in a session, or by the NSURLRequest
 * HTTPShouldUsePipelining property.
 *
 * The underlying connection is no longer considered part of the HTTP
 * connection cache and won't count against the total number of
 * connections per host.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didBecomeStreamTask:(NSURLSessionStreamTask *)streamTask {
    NSLog(@"3-->%@",dataTask);
}

/* Sent when data is available for the delegate to consume.  It is
 * assumed that the delegate will retain and not copy the data.  As
 * the data may be discontiguous, you should use
 * [NSData enumerateByteRangesUsingBlock:] to access it.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    NSLog(@"4-->%@",data);
}

/* Invoke the completion routine with a valid NSCachedURLResponse to
 * allow the resulting data to be cached, or pass nil to prevent
 * caching. Note that there is no guarantee that caching will be
 * attempted for a given resource, and you should not rely on this
 * message to receive the resource data.
 */
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse * _Nullable cachedResponse))completionHandler {
     NSLog(@"5-->%@",proposedResponse);
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
