//
//  WebViewController.m
//  Maps-Google
//
//  Created by Aditya Narayan on 5/4/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //init WkWebView
    self.myWebView = [[WKWebView alloc]initWithFrame:self.view.frame];

    //create url request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString: self.displayURL]];
    
    //send request
    [self.myWebView loadRequest:request];
    
    //assign webview to view
    self.myWebView.frame = self.view.frame;
    
    //add webview to view
    [self.view addSubview:self.myWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)dealloc {
}

@end
