//
//  UIWebViewVC.m
//  webview
//
//  Created by JiWuChao on 2018/10/30.
//  Copyright © 2018 JiWuChao. All rights reserved.
//

#import "UIWebViewVC.h"

#import "WebViewDemoDefine.h"

#import <JavaScriptCore/JavaScriptCore.h>

@interface UIWebViewVC ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@property (nonatomic, strong) JSContext *jsContext ;

@end

@implementation UIWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://wuchao.net.cn"]];
//    [self.webView loadRequest:request];
    
    
     [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"]]]];
    //点击返回，逐级返回
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self.webView action:@selector(goBack)];
    self.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}


- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (JSContext *)jsContext {
    if (!_jsContext) {
        //获取该UIWebView的javascript上下文
        _jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];;
    }
    return _jsContext;
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    
    /*
     darkangel://smsLogin?username=12323123&code=892845
     
     scheme: darkangel
     user:(null)
     host:smsLogin
     absoluteString:darkangel://smsLogin?username=12323123&code=892845
     path:
     port:(null)
     fragment:(null)
     parameterString:(null)
     query:username=12323123&code=892845
     
     */
    
    
    NSURL *url = request.URL;
    NSLog(@"scheme: %@,user:%@,host:%@,absoluteString:%@,path:%@,port:%@,fragment:%@,parameterString:%@,query:%@",url.scheme,url.user,url.host,url.absoluteString,url.path,url.port,url.fragment,url.parameterString,url.query);
    if ([url.scheme isEqualToString:JWCWebViewDemoScheme]) {
        [url.host isEqualToString:JWCWebViewDemoHostSmsLogin];
        NSLog(@"短信验证码登录，参数为 %@", url.query);
        return NO;
        
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"start");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"over");
    //更新标题，这是上面的讲过的方法
//    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

    [self.jsContext setExceptionHandler:^(JSContext *context, JSValue *exception) {
        NSLog(@"exception--:%@",exception);
    }];
    //这也是一种获取标题的方法。
    JSValue *value = [self.jsContext evaluateScript:@"document.title"];
    //更新标题
    self.navigationItem.title = value.toString;
    
    [self convertJSFunctionsToOCMethods];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"error - %@",error);
}


//js调用oc
//其中share就是js的方法名称，赋给是一个block 里面是oc代码
//此方法最终将打印出所有接收到的参数，js参数是不固定的
- (void)convertJSFunctionsToOCMethods {
    self.jsContext[@"share"] = ^() {
        //获取到share里的所有参数
        NSArray<JSValue *> *args = [JSContext currentArguments];
        //args中的元素是JSValue，需要转成OC的对象
        NSMutableArray *message = [NSMutableArray arrayWithCapacity:10];
        for (JSValue *value in args) {
            [message addObject:[value toObject]];
        }
        NSLog(@"点击分享js传回的参数：\n%@", message);
    };
    
    // 返回上一页
    typeof(self) selfWeak = self;
    self.jsContext[@"pop"] = ^() {
        [selfWeak.navigationController popViewControllerAnimated:YES];
    };
}



@end
