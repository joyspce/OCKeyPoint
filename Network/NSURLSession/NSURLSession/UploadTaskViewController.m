//
//  UploadTaskViewController.m
//  NSURLSession
//
//  Created by JiWuChao on 2018/9/10.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "UploadTaskViewController.h"

/*
 
 添加upload任务
 
 1 - uploadTaskWithRequest:fromData: : 通过HTTP请求发送data给指定URL
 2 - uploadTaskWithRequest:fromData:completionHandler: : 通过HTTP请求发送data给指定URL, 在completionHandler中处理数据. 该方法会绕过代理方法(除了身份认证挑战的代理方法)
 3 - uploadTaskWithRequest:fromFile: : 通过HTTP请求发送指定文件给指定URL
 4 - uploadTaskWithRequest:fromFile:completionHandler: : 通过HTTP请求发送指定文件给指定URL, 在completionHandler中处理数据. 该方法会绕过代理方法(除了身份认证挑战的代理方法)
 uploadTaskWithStreamedRequest : 通过HTTP请求发送指定URLRequest数据流给指定URL
 
 
*/


@interface UploadTaskViewController ()<NSURLSessionDelegate>

@end

@implementation UploadTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - NSURLSessionDelegate : 作为所有代理的基类，定义了网络请求最基础的代理方法

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

#pragma mark - NSURLSessionTaskDelegate:定义了网络请求任务相关的代理方法。


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

#pragma mark - 上传数据去服务器期间, 代理会周期性收到URLSession:task:didSendBodyData:totalBytesSent:totalBytesExpectedToSend:回调并获得上传进度的报告.

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
    NSLog(@"%s",__func__);
    NSLog(@"metrics -> %@",metrics);
}

/*
 清求出错的时候调用
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    NSLog(@"%s",__func__);
    NSLog(@"error:%@",error);
}


@end
