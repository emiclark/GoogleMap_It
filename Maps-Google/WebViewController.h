//
//  WebViewController.h
//  Maps-Google
//
//  Created by Aditya Narayan on 5/4/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import <Foundation/Foundation.h>

@interface WebViewController : UIViewController <UIWebViewDelegate, WKNavigationDelegate>

@property (retain, nonatomic) NSString *displayURL;
@property (strong, nonatomic) IBOutlet WKWebView *myWebView;



@end
