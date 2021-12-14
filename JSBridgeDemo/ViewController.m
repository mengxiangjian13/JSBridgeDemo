//
//  ViewController.m
//  JSBridgeDemo
//
//  Created by mengxiangjian on 2021/12/14.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>

@interface ViewController () <WKUIDelegate, WKScriptMessageHandler>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"Call JS"
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(callJSAction:)];
    self.navigationItem.rightBarButtonItem = item;
    
    [self.view addSubview:self.webView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"1"
                                                     ofType:@"html"];
    NSURL *baseURL = [[NSBundle mainBundle] bundleURL];
    NSString *html = [NSString stringWithContentsOfFile:path
                                               encoding:NSUTF8StringEncoding
                                                  error:nil];
    
    [self.webView loadHTMLString:html
                         baseURL:baseURL];
    
    [self loadScript];
}

- (WKWebView *)webView {
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                      configuration:config];
        _webView.UIDelegate = self;
    }
    return _webView;
}

- (void)callJSAction:(id)sender {
    UIAlertController *actionsheet = [UIAlertController alertControllerWithTitle:@"Call JS Func"
                                                                         message:@""
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"No Param"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.webView evaluateJavaScript:@"alertMobile()"
                           completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"One Param"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.webView evaluateJavaScript:@"alertName('一个参数')"
                           completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            
        }];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"Two Params"
                                                      style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.webView evaluateJavaScript:@"alertSendMsg('第一个参数','第二个参数')"
                           completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            
        }];
    }];
    [actionsheet addAction:action1];
    [actionsheet addAction:action2];
    [actionsheet addAction:action3];
    
    [self presentViewController:actionsheet
                       animated:YES
                     completion:nil];
}

- (void)loadScript {
    //JS调用OC 添加处理脚本
    WKUserContentController *userCC = self.webView.configuration.userContentController;
    //JS调用OC 添加处理脚本
    [userCC addScriptMessageHandler:self name:@"showMobile"];
    [userCC addScriptMessageHandler:self name:@"showName"];
    [userCC addScriptMessageHandler:self name:@"showSendMsg"];
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    if (message) {
        NSString *name = message.name;
        id params = message.body;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:name
                                                                       message:[NSString stringWithFormat:@"%@", params] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
    }
}

@end
