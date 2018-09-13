//
//  BgDownloadManager.m
//  NSURLSession
//
//  Created by JiWuChao on 2018/9/13.
//  Copyright © 2018年 JiWuChao. All rights reserved.
//

#import "BgDownloadManager.h"

@interface BgDownloadManager ()

@property (nonatomic,strong) NSURLSessionDownloadTask *downloadBg;

@property (nonatomic,strong) NSURLSession *sessionBg;

@property (nonatomic, copy) NSString *downloadAds;

@end


@implementation BgDownloadManager

+ (instancetype)shared {
    static BgDownloadManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BgDownloadManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (NSURLSession *)sessionBg {
    if (!_sessionBg) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:@"com.jwc.jsjjsjsudjdjj"];
        _sessionBg = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _sessionBg;
}


- (NSURLSessionDownloadTask *)downloadBg {
    if (!_downloadBg) {
        _downloadBg = [self.sessionBg downloadTaskWithURL:[NSURL URLWithString:self.downloadAds]];
    }
    return _downloadBg;
}

- (void)startWithAds:(NSString *)ads {
    self.downloadAds = ads;
    if (self.downloadAds.length == 0) {
        return;
    }
    [self.downloadBg resume];
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
    
    NSLog(@"后台下载完成:%s",__func__);
}

#pragma mark - NSURLSessionTaskDelegate::定义了网络请求任务相关的代理方法。


/**
 用于后台任务。这个方法告诉代理一个延迟的task（通过设置earliestBeginDate）要开始执行了
 只有在等待网络或者需要被新的请求替代而导致当前请求可能会变过时的时候才需要实现这个方法
 你需要调用此方法参数中的completionHandler，并提供disposition指示如何做下一步处理，
 disposition提供3个值
 
 NSURLSessionDelayedRequestContinueLoading: 继续执行
 NSURLSessionDelayedRequestUseNewRequest: 用新的request替换旧的
 NSURLSessionDelayedRequestCancel: 取消请求
 
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
willBeginDelayedRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLSessionDelayedRequestDisposition disposition, NSURLRequest * _Nullable newRequest))completionHandler  API_AVAILABLE(ios(11.0)){
    NSLog(@"%s",__func__);
    if (@available(iOS 11.0, *)) {
        completionHandler(NSURLSessionDelayedRequestContinueLoading,request);
    } else {
        // Fallback on earlier versions
    }
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
}

/*
 
 对于一个通过 downloadTaskWithResumeData: 创建的下载任务, session会调用代理的URLSession:downloadTask:didResumeAtOffset:expectedTotalBytes:方法.
 */
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didResumeAtOffset:(int64_t)fileOffset expectedTotalBytes:(int64_t)expectedTotalBytes {
    // 重新下载时调用这个方法
    NSLog(@"重新下载--");
}


@end
