//
//  DataTaskViewController.m
//  NSURLSession
//
//  Created by JiWuChao on 2018/9/10.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "DataTaskViewController.h"

/*
 添加data任务
 
 
 1 - dataTaskWithURL: : 获取指定URL内容
 2 - dataTaskWithURL:completionHandler: : 获取指定URL内容, 在completionHandler中处理数据. 该方法会绕过代理方法(除了身份认证挑战的代理方法)
 3 - dataTaskWithRequest: : 获取指定URLRequest内容
 4 - dataTaskWithRequest:completionHandler: : 获取指定URLRequest内容, 在completionHandler中处理数据. 该方法会绕过代理方法(除了身份认证挑
 
 
 */


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


@interface DataTaskViewController ()<NSURLSessionDelegate>

@end

@implementation DataTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.timeoutIntervalForRequest = 30;
    NSOperationQueue *queue = [NSOperationQueue mainQueue];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:queue];
    
    NSURL *url = [NSURL URLWithString:@"http://jsonplaceholder.typicode.com/users"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url];
    //    self.dataTask = [session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    //        //        NSLog(@"res = %@",response);
    //        NSLog(@"11----%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
    //        //打印解析后的json数据
    //        NSLog(@"22---%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
    //
    //    }];
    
    
    
//    [session dataTaskWithURL:<#(nonnull NSURL *)#> completionHandler:<#^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)completionHandler#>];
    
    [dataTask resume];
    
    /*
    //1、创建NSURLSession对象
    NSURLSession *session = [NSURLSession sharedSession];
    
    //2、利用NSURLSession创建任务(task)
    NSURL *url = [NSURL URLWithString:@"http://www.xxx.com/login"];
    
    //3 创建请求对象里面包含请求体
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"username=myName&pwd=myPsd" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        //打印解析后的json数据
        //NSLog(@"%@", [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]);
        
    }];

    */
    

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
     NSLog(@"%s",__func__);
    NSLog(@"metrics -> %@",metrics);
}


 /*
 任何task完成的时候, 都会调用URLSession:task:didCompleteWithError:方法, error有可能为nil(请求成功), 不为nil(请求失败)
 
 1 请求失败, 但是该任务是可恢复下载的, 那么error对象的userInfo字典里有一个NSURLSessionDownloadTaskResumeData对应的value, 你应该把这个值传给downloadTaskWithResumeData:方法重新恢复下载
 2 请求失败, 但是任务无法恢复下载, 那么应该重新创建一个下载任务并从头开始下载.
 3 因为其他原因(如服务器错误等等), 创建并恢复请求.
 
 Note
 NSURLSession不会收到服务器传来的错误, 代理只会收到客户端出现的错误, 例如无法解析主机名或无法连接上主机等等. 客户端错误定义在URL Loading System Error Codes. 服务端错误通过HTTP状态法进行传输, 详情请看NSHTTPURLResponse和NSURLResponse类.
 */

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
     NSLog(@"%s",__func__);
    NSLog(@"error:%@",error);
}






#pragma mark - NSURLSessionDataDelegate: 用于普通数据任务和上传任务。


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    NSLog(@"1-->%@",response);
    NSLog(@"开始接收数据");
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
//    NSLog(@"4-->%@",data);
    NSLog(@"正在接收数据");
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


@end
