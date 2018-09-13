//
//  DownloadTaskViewController.m
//  NSURLSession
//
//  Created by JiWuChao on 2018/9/10.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "DownloadTaskViewController.h"

#import "BgDownloadManager.h"

@interface DownloadTaskViewController ()<NSURLSessionDelegate>

@property (nonatomic, strong)NSURLSessionDownloadTask *download;

@property (nonatomic, strong) NSData *resumeData;

@property (nonatomic, strong) NSURLSession *session;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;



 //MAEK:后台下载相关

@property (weak, nonatomic) IBOutlet UIProgressView *backgroundProgress;

@property (nonatomic, strong) NSURLSessionDownloadTask *bgdownloadTask;


@end


/*
    添加download任务
 
 1 - downloadTaskWithURL: : 下载指定URL内容
 2 - downloadTaskWithURL:completionHandler: : 下载指定URL内容, 在completionHandler中处理数据. 该方法会绕过代理方法(除了身份认证挑战的代理方法)
 3 - downloadTaskWithRequest: : 下载指定URLRequest内容
 4 - downloadTaskWithRequest:completionHandler: : 下载指定URLRequest内容, 在completionHandler中处理数据. 该方法会绕过代理方法(除了身份认证挑战的代理方法)
 5 - downloadTaskWithResumeData: : 创建一个之前被取消/下载失败的download task
 6 - downloadTaskWithResumeData:completionHandler: : 创建一个之前被取消/下载失败的download task, 在completionHandler中处理数据. 该方法会绕过代理方法(除了身份认证挑战的代理方法)
 
 
 */


@implementation DownloadTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //对于一个通过downloadTaskWithResumeData:创建的下载任务, session会调用代理的URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes:方法.

    //    self.download = [session downloadTaskWithResumeData:<#(nonnull NSData *)#>];
//    self.download = [session downloadTaskWithResumeData:<#(nonnull NSData *)#> completionHandler:<#^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error)completionHandler#>];
    self.progress.progress = 0;
}


- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

- (NSURLSessionDownloadTask *)download {
    if (!_download) {
        _download = [self.session downloadTaskWithURL:[NSURL URLWithString:@"http://he.yinyuetai.com/uploads/videos/common/8AE4015CA6F6B544282B29F4C1DC0C0A.mp4"]];
    }
    return _download;
}

- (NSURLSessionDownloadTask *)bgdownloadTask {
    if (!_bgdownloadTask) {
        _bgdownloadTask = [[self backgroundURLSession] downloadTaskWithURL:[NSURL URLWithString:@"http://he.yinyuetai.com/uploads/videos/common/8AE4015CA6F6B544282B29F4C1DC0C0A.mp4"]];
    }
    return _bgdownloadTask;
}



- (NSURLSession *)backgroundURLSession {
    static NSURLSession *session = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *identifier = @"com.jwc.appId.BackgroundSession";
        NSURLSessionConfiguration* sessionConfig = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:identifier];
        session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                delegate:self
                                           delegateQueue:[NSOperationQueue mainQueue]];
    });
    return session;
}


- (IBAction)start:(id)sender {
    [self.download resume];
    
}

- (IBAction)pause:(id)sender {
//    [self.download suspend];
    [self.download cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
    }];
}

- (IBAction)restart:(id)sender {
    self.download = nil;
    if (self.resumeData.length == 0) {
        [self start:nil];
        return;
    }
    self.download = [self.session downloadTaskWithResumeData:self.resumeData];
    [self.download resume];
}

- (IBAction)cancle:(id)sender {
//    [self.download cancel];
    [self.download cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        self.resumeData = resumeData;
    }];
}

- (IBAction)backgroundDownloadAction:(id)sender {
    [[BgDownloadManager shared] startWithAds:@"http://he.yinyuetai.com/uploads/videos/common/8AE4015CA6F6B544282B29F4C1DC0C0A.mp4"];
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

/*
 //在应用处于后台，且后台任务下载完成时回调
 */
- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session {
    NSLog(@"%s",__func__);
}

#pragma mark - NSURLSessionTaskDelegate::定义了网络请求任务相关的代理方法。


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
 任何task完成的时候, 都会调用URLSession:task:didCompleteWithError:方法, error有可能为nil(请求成功), 不为nil(请求失败)
 
 1 请求失败, 但是该任务是可恢复下载的, 那么error对象的userInfo字典里有一个NSURLSessionDownloadTaskResumeData对应的value, 你应该把这个值传给downloadTaskWithResumeData:方法重新恢复下载
 2 请求失败, 但是任务无法恢复下载, 那么应该重新创建一个下载任务并从头开始下载.
 3 因为其他原因(如服务器错误等等), 创建并恢复请求.
 
 Note
 NSURLSession不会收到服务器传来的错误, 代理只会收到客户端出现的错误, 例如无法解析主机名或无法连接上主机等等. 客户端错误定义在URL Loading System Error Codes. 服务端错误通过HTTP状态法进行传输, 详情请看NSHTTPURLResponse和NSURLResponse类.
 */

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    NSLog(@"downloadTask 结束 --- error:%@",error);
    NSLog(@"NSURLSessionDownloadTaskResumeData = %@",[error.userInfo valueForKey:NSURLSessionDownloadTaskResumeData]);
}




#pragma mark - NSURLSessionDownloadDelegate: 用于下载任务相关的代理方法，比如下载进度等等

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
    self.progress.progress = progress;
}

/*
 
 对于一个通过 downloadTaskWithResumeData: 创建的下载任务, session会调用代理的URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes:方法.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    // 重新下载时调用这个方法
    NSLog(@"重新下载--");
}








@end
