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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
//    NSLog(@"scheme: %@,user:%@,host:%@,absoluteString:%@,path:%@,port:%@,fragment:%@,parameterString:%@",url.scheme,url.user,url.host,url.absoluteString,url.path,url.port,url.fragment,url.parameterString);
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
    //self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    //获取该UIWebView的javascript上下文
    JSContext *jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    //这也是一种获取标题的方法。
    JSValue *value = [jsContext evaluateScript:@"document.title"];
    //更新标题
    self.navigationItem.title = value.toString;

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"error - %@",error);
}


@end
