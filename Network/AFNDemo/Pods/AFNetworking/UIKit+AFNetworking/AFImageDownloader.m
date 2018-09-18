// AFImageDownloader.m
// Copyright (c) 2011–2016 Alamofire Software Foundation ( http://alamofire.org/ )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <TargetConditionals.h>

#if TARGET_OS_IOS || TARGET_OS_TV

#import "AFImageDownloader.h"
#import "AFHTTPSessionManager.h"

#pragma mark - AFImageDownloaderResponseHandler start

@interface AFImageDownloaderResponseHandler : NSObject
@property (nonatomic, strong) NSUUID *uuid;
@property (nonatomic, copy) void (^successBlock)(NSURLRequest*, NSHTTPURLResponse*, UIImage*);
@property (nonatomic, copy) void (^failureBlock)(NSURLRequest*, NSHTTPURLResponse*, NSError*);
@end

@implementation AFImageDownloaderResponseHandler

- (instancetype)initWithUUID:(NSUUID *)uuid
                     success:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, UIImage *responseObject))success
                     failure:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure {
    if (self = [self init]) {
        self.uuid = uuid;
        self.successBlock = success;
        self.failureBlock = failure;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat: @"<AFImageDownloaderResponseHandler>UUID: %@", [self.uuid UUIDString]];
}

@end

#pragma mark - AFImageDownloaderResponseHandler enda

#pragma mark - AFImageDownloaderMergedTask start


@interface AFImageDownloaderMergedTask : NSObject
@property (nonatomic, strong) NSString *URLIdentifier;
@property (nonatomic, strong) NSUUID *identifier;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, strong) NSMutableArray <AFImageDownloaderResponseHandler*> *responseHandlers;

@end

@implementation AFImageDownloaderMergedTask

- (instancetype)initWithURLIdentifier:(NSString *)URLIdentifier identifier:(NSUUID *)identifier task:(NSURLSessionDataTask *)task {
    if (self = [self init]) {
        self.URLIdentifier = URLIdentifier;
        self.task = task;
        self.identifier = identifier;
        self.responseHandlers = [[NSMutableArray alloc] init];
    }
    return self;
}
//添加任务完成回调
- (void)addResponseHandler:(AFImageDownloaderResponseHandler*)handler {
    [self.responseHandlers addObject:handler];
}
//移除任务完成回调
- (void)removeResponseHandler:(AFImageDownloaderResponseHandler*)handler {
    [self.responseHandlers removeObject:handler];
}

@end
#pragma mark - AFImageDownloaderMergedTask end

@implementation AFImageDownloadReceipt

- (instancetype)initWithReceiptID:(NSUUID *)receiptID task:(NSURLSessionDataTask *)task {
    if (self = [self init]) {
        self.receiptID = receiptID;
        self.task = task;
    }
    return self;
}

@end




@interface AFImageDownloader ()

@property (nonatomic, strong) dispatch_queue_t synchronizationQueue;
@property (nonatomic, strong) dispatch_queue_t responseQueue;

@property (nonatomic, assign) NSInteger maximumActiveDownloads;
@property (nonatomic, assign) NSInteger activeRequestCount;

@property (nonatomic, strong) NSMutableArray *queuedMergedTasks;
@property (nonatomic, strong) NSMutableDictionary *mergedTasks;

@end

@implementation AFImageDownloader

+ (NSURLCache *)defaultURLCache {
    
    // It's been discovered that a crash will occur on certain versions
    // of iOS if you customize the cache.
    //
    // More info can be found here: https://devforums.apple.com/message/1102182#1102182
    //
    // When iOS 7 support is dropped, this should be modified to use
    // NSProcessInfo methods instead.
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.2" options:NSNumericSearch] == NSOrderedAscending) {
        return [NSURLCache sharedURLCache];
    }
    //设置一个系统缓存，内存缓存为20M，磁盘缓存为150M，
    //这个是系统级别维护的缓存。
    /*
     大家看到这可能迷惑了，怎么这么多cache，那AF做图片缓存到底用哪个呢？答案是AF自己控制的图片缓存用```AFAutoPurgingImageCache```，而```NSUrlRequest```的缓存由它自己内部根据策略去控制，用的是```NSURLCache```，不归AF处理，只需在configuration中设置上即可。
     - 那么看到这有些小伙伴又要问了，为什么不直接用```NSURLCache```，还要自定义一个```AFAutoPurgingImageCache```呢？原来是因为```NSURLCache```的诸多限制，例如只支持get请求等等。而且因为是系统维护的，我们自己的可控度不强，并且如果需要做一些自定义的缓存处理，无法实现。
     - 更多关于```NSURLCache```的内容，大家可以自行查阅。
   
     
     */
    return [[NSURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024
                                         diskCapacity:150 * 1024 * 1024
                                             diskPath:@"com.alamofire.imagedownloader"];
}

+ (NSURLSessionConfiguration *)defaultURLSessionConfiguration {
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];

    //TODO set the default HTTP headers

    configuration.HTTPShouldSetCookies = YES;
    configuration.HTTPShouldUsePipelining = NO;

    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    //是否允许蜂窝网络，手机网
    configuration.allowsCellularAccess = YES;
    //默认超时
    configuration.timeoutIntervalForRequest = 60.0;
    //设置的图片缓存对象
    configuration.URLCache = [AFImageDownloader defaultURLCache];

    return configuration;
}

- (instancetype)init {
    NSURLSessionConfiguration *defaultConfiguration = [self.class defaultURLSessionConfiguration];
    return [self initWithSessionConfiguration:defaultConfiguration];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    sessionManager.responseSerializer = [AFImageResponseSerializer serializer];

    return [self initWithSessionManager:sessionManager
                 downloadPrioritization:AFImageDownloadPrioritizationFIFO
                 maximumActiveDownloads:4
                             imageCache:[[AFAutoPurgingImageCache alloc] init]];
}




/**
 这边初始化了一些属性，这些属性跟着注释看应该很容易明白其作用。主要需要注意的就是，这里创建了两个queue：
    一个串行的请求queue，和一个并行的响应queue。
 - 这个串行queue,是用来做内部生成task等等一系列业务逻辑的。它保证了我们在这些逻辑处理中的线程安全问题（迷惑的接着往下看）。
 - 这个并行queue，被用来做网络请求完成的数据回调。
 
 */
- (instancetype)initWithSessionManager:(AFHTTPSessionManager *)sessionManager
                downloadPrioritization:(AFImageDownloadPrioritization)downloadPrioritization
                maximumActiveDownloads:(NSInteger)maximumActiveDownloads
                            imageCache:(id <AFImageRequestCache>)imageCache {
    if (self = [super init]) {
        self.sessionManager = sessionManager;
        //定义下载任务的顺序，默认FIFO，先进先出-队列模式，还有后进先出-栈模式

        self.downloadPrioritizaton = downloadPrioritization;
        //最大的下载数

        self.maximumActiveDownloads = maximumActiveDownloads;
         //自定义的cache
        self.imageCache = imageCache;
        //队列中的任务，待执行的
        self.queuedMergedTasks = [[NSMutableArray alloc] init];
         //合并的任务，所有任务的字典
        self.mergedTasks = [[NSMutableDictionary alloc] init];
        //活跃的request数
        self.activeRequestCount = 0;
        //用UUID来拼接名字
        NSString *name = [NSString stringWithFormat:@"com.alamofire.imagedownloader.synchronizationqueue-%@", [[NSUUID UUID] UUIDString]];
        //创建一个串行的queue
        self.synchronizationQueue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_SERIAL);
        
        name = [NSString stringWithFormat:@"com.alamofire.imagedownloader.responsequeue-%@", [[NSUUID UUID] UUIDString]];
        //创建并行queue
        self.responseQueue = dispatch_queue_create([name cStringUsingEncoding:NSASCIIStringEncoding], DISPATCH_QUEUE_CONCURRENT);
    }

    return self;
}

+ (instancetype)defaultInstance {
    static AFImageDownloader *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (nullable AFImageDownloadReceipt *)downloadImageForURLRequest:(NSURLRequest *)request
                                                        success:(void (^)(NSURLRequest * _Nonnull, NSHTTPURLResponse * _Nullable, UIImage * _Nonnull))success
                                                        failure:(void (^)(NSURLRequest * _Nonnull, NSHTTPURLResponse * _Nullable, NSError * _Nonnull))failure {
    return [self downloadImageForURLRequest:request withReceiptID:[NSUUID UUID] success:success failure:failure];
}

/**
 就这么一个非常非常长的方法，这个方法执行的内容都是在我们之前创建的串行queue中，同步的执行的，这是因为这个方法绝大多数的操作都是需要线程安全的。可以对着源码和注释来看，我们在这讲下它做了什么：
 1. 首先做了一个url的判断，如果为空则返回失败Block。
 2. 判断这个需要请求的url，是不是已经被生成的task中，如果是的话，则多添加一个回调处理就可以。回调处理对象为```AFImageDownloaderResponseHandler```。这个类非常简单，总共就如下3个属性：
 
 */
- (nullable AFImageDownloadReceipt *)downloadImageForURLRequest:(NSURLRequest *)request
                                                  withReceiptID:(nonnull NSUUID *)receiptID
                                                        success:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse  * _Nullable response, UIImage *responseObject))success
                                                        failure:(nullable void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure {
   
    /*
     //还是类似之前的，同步串行去做下载的事 生成一个task,这些事情都是在当前线程中串行同步做的，
     所以不用担心线程安全问题。

     */
    __block NSURLSessionDataTask *task = nil;
    dispatch_sync(self.synchronizationQueue, ^{
        NSString *URLIdentifier = request.URL.absoluteString;
        if (URLIdentifier == nil) {
            if (failure) {
                NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorBadURL userInfo:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    failure(request, nil, error);
                });
            }
            return;
        }

        // 1) Append the success and failure blocks to a pre-existing request if it already exists
        
        /*
         //如果这个任务已经存在，表明还正在下载中， 则添加成功失败Block,然后直接返回，即一个url用一个request,可以响应好几个block
         //从自己task字典中根据Url去取AFImageDownloaderMergedTask，里面有task id url等等信息
         */
        
        AFImageDownloaderMergedTask *existingMergedTask = self.mergedTasks[URLIdentifier];
        if (existingMergedTask != nil) {
            //里面包含成功和失败Block和UUid

            AFImageDownloaderResponseHandler *handler = [[AFImageDownloaderResponseHandler alloc] initWithUUID:receiptID success:success failure:failure];
            //添加handler

            [existingMergedTask addResponseHandler:handler];
            task = existingMergedTask.task;
            return;
        }

        // 2) Attempt to load the image from the image cache if the cache policy allows it
        //这3种情况都会去加载缓存
        switch (request.cachePolicy) {
            case NSURLRequestUseProtocolCachePolicy:
            case NSURLRequestReturnCacheDataElseLoad:
            case NSURLRequestReturnCacheDataDontLoad: {
                //从cache中根据request拿数据
                UIImage *cachedImage = [self.imageCache imageforRequest:request withAdditionalIdentifier:nil];
                if (cachedImage != nil) {
                    if (success) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            success(request, nil, cachedImage);
                        });
                    }
                    return;
                }
                break;
            }
            default:
                break;
        }

        // 3) Create the request and set up authentication, validation and response serialization
        //走到这说明即没有请求中的request,也没有cache,开始请求

        NSUUID *mergedTaskIdentifier = [NSUUID UUID];
        NSURLSessionDataTask *createdTask;
        __weak __typeof__(self) weakSelf = self;
        //用sessionManager的去请求，注意，只是创建task,还是挂起状态

        createdTask = [self.sessionManager
                       dataTaskWithRequest:request
                       uploadProgress:nil
                       downloadProgress:nil
                       completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                           //在responseQueue中回调数据,初始化为并行queue
                           dispatch_async(self.responseQueue, ^{
                               __strong __typeof__(weakSelf) strongSelf = weakSelf;
                               //拿到当前的task
                               AFImageDownloaderMergedTask *mergedTask = strongSelf.mergedTasks[URLIdentifier];
                               //如果之前的task数组中，有这个请求的任务task，则从数组中移除
                               if ([mergedTask.identifier isEqual:mergedTaskIdentifier]) {
                                   //安全的移除，并返回当前被移除的AF task
                                   mergedTask = [strongSelf safelyRemoveMergedTaskWithURLIdentifier:URLIdentifier];
                                    //请求错误
                                   if (error) {
                                       //去遍历task所有响应的处理
                                       for (AFImageDownloaderResponseHandler *handler in mergedTask.responseHandlers) {
                                           //主线程，调用失败的Block
                                           if (handler.failureBlock) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   handler.failureBlock(request, (NSHTTPURLResponse*)response, error);
                                               });
                                           }
                                       }
                                   } else {
                                        //成功根据request,往cache里添加
                                       if ([strongSelf.imageCache shouldCacheImage:responseObject forRequest:request withAdditionalIdentifier:nil]) {
                                           [strongSelf.imageCache addImage:responseObject forRequest:request withAdditionalIdentifier:nil];
                                       }
                                        //调用成功Block
                                       for (AFImageDownloaderResponseHandler *handler in mergedTask.responseHandlers) {
                                           if (handler.successBlock) {
                                               dispatch_async(dispatch_get_main_queue(), ^{
                                                   handler.successBlock(request, (NSHTTPURLResponse*)response, responseObject);
                                               });
                                           }
                                       }
                                       
                                   }
                               }
                               //减少活跃的任务数
                               [strongSelf safelyDecrementActiveTaskCount];
                               // 下载完成此任务之后 判断是否执行下一个任务
                               [strongSelf safelyStartNextTaskIfNecessary];
                           });
                       }];

        // 4) Store the response handler for use when the request completes
            //创建handler
        AFImageDownloaderResponseHandler *handler = [[AFImageDownloaderResponseHandler alloc] initWithUUID:receiptID
                                                                                                   success:success
                                                                                                   failure:failure];
        //创建task
        AFImageDownloaderMergedTask *mergedTask = [[AFImageDownloaderMergedTask alloc]
                                                   initWithURLIdentifier:URLIdentifier
                                                   identifier:mergedTaskIdentifier
                                                   task:createdTask];
         //添加handler
        [mergedTask addResponseHandler:handler];
        //往当前任务字典里添加任务
        self.mergedTasks[URLIdentifier] = mergedTask;

        // 5) Either start the request or enqueue it depending on the current active request count
        //判断当前正在下载的任务是否超过最大并行数，如果没有则开始下载，否则先加到等待的数组中去:
        if ([self isActiveRequestCountBelowMaximumLimit]) {
            [self startMergedTask:mergedTask];
        } else {
            [self enqueueMergedTask:mergedTask];
        }
        //拿到最终生成的task
        task = mergedTask.task;
    });
    if (task) {
        //创建一个AFImageDownloadReceipt并返回，里面就多一个receiptID。
        return [[AFImageDownloadReceipt alloc] initWithReceiptID:receiptID task:task];
    } else {
        return nil;
    }
}
//根据AFImageDownloadReceipt来取消任务，即对应一个响应回调。

- (void)cancelTaskForImageDownloadReceipt:(AFImageDownloadReceipt *)imageDownloadReceipt {
    dispatch_sync(self.synchronizationQueue, ^{
        //拿到url
        NSString *URLIdentifier = imageDownloadReceipt.task.originalRequest.URL.absoluteString;
        //根据url拿到task
        AFImageDownloaderMergedTask *mergedTask = self.mergedTasks[URLIdentifier];
         //快速遍历查找某个下标，如果返回YES，则index为当前下标
        NSUInteger index = [mergedTask.responseHandlers indexOfObjectPassingTest:^BOOL(AFImageDownloaderResponseHandler * _Nonnull handler, __unused NSUInteger idx, __unused BOOL * _Nonnull stop) {
            return handler.uuid == imageDownloadReceipt.receiptID;
        }];

        if (index != NSNotFound) {
            //移除响应处理
            AFImageDownloaderResponseHandler *handler = mergedTask.responseHandlers[index];
            [mergedTask removeResponseHandler:handler];
            NSString *failureReason = [NSString stringWithFormat:@"ImageDownloader cancelled URL request: %@",imageDownloadReceipt.task.originalRequest.URL.absoluteString];
            NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey:failureReason};
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCancelled userInfo:userInfo];
            //并调用失败block，原因为取消
            if (handler.failureBlock) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler.failureBlock(imageDownloadReceipt.task.originalRequest, nil, error);
                });
            }
        }
        //如果任务里的响应回调为空或者状态为挂起，则取消task,并且从字典中移除
        if (mergedTask.responseHandlers.count == 0 && mergedTask.task.state == NSURLSessionTaskStateSuspended) {
            [mergedTask.task cancel];
            [self removeMergedTaskWithURLIdentifier:URLIdentifier];
        }
    });
}
//移除task相关，用同步串行的形式，防止移除中出现重复移除一系列问题
- (AFImageDownloaderMergedTask*)safelyRemoveMergedTaskWithURLIdentifier:(NSString *)URLIdentifier {
    __block AFImageDownloaderMergedTask *mergedTask = nil;
    dispatch_sync(self.synchronizationQueue, ^{
        mergedTask = [self removeMergedTaskWithURLIdentifier:URLIdentifier];
    });
    return mergedTask;
}

//This method should only be called from safely within the synchronizationQueue
- (AFImageDownloaderMergedTask *)removeMergedTaskWithURLIdentifier:(NSString *)URLIdentifier {
    AFImageDownloaderMergedTask *mergedTask = self.mergedTasks[URLIdentifier];
    [self.mergedTasks removeObjectForKey:URLIdentifier];
    return mergedTask;
}

- (void)safelyDecrementActiveTaskCount {
    dispatch_sync(self.synchronizationQueue, ^{
        if (self.activeRequestCount > 0) {
            self.activeRequestCount -= 1;
        }
    });
}
//如果可以，则开启下一个任务
- (void)safelyStartNextTaskIfNecessary {
    //回到串行queue
    dispatch_sync(self.synchronizationQueue, ^{
         //先判断并行数限制
        if ([self isActiveRequestCountBelowMaximumLimit]) {
            while (self.queuedMergedTasks.count > 0) {
                //获取数组中第一个task
                AFImageDownloaderMergedTask *mergedTask = [self dequeueMergedTask];
                  //如果状态是挂起状态
                if (mergedTask.task.state == NSURLSessionTaskStateSuspended) {
                    [self startMergedTask:mergedTask];
                    break;
                }
            }
        }
    });
}

- (void)startMergedTask:(AFImageDownloaderMergedTask *)mergedTask {
    [mergedTask.task resume];
    ++self.activeRequestCount;
}

- (void)enqueueMergedTask:(AFImageDownloaderMergedTask *)mergedTask {
    switch (self.downloadPrioritizaton) {
        case AFImageDownloadPrioritizationFIFO:
            [self.queuedMergedTasks addObject:mergedTask];
            break;
        case AFImageDownloadPrioritizationLIFO:
            [self.queuedMergedTasks insertObject:mergedTask atIndex:0];
            break;
    }
}

- (AFImageDownloaderMergedTask *)dequeueMergedTask {
    AFImageDownloaderMergedTask *mergedTask = nil;
    mergedTask = [self.queuedMergedTasks firstObject];
    [self.queuedMergedTasks removeObject:mergedTask];
    return mergedTask;
}

- (BOOL)isActiveRequestCountBelowMaximumLimit {
    return self.activeRequestCount < self.maximumActiveDownloads;
}

@end

#endif
