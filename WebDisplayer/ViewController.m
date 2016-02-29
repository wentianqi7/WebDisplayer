//
//  ViewController.m
//  Testing
//
//  Created by Tianqi Wen on 2/7/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // retrieving source code (json) from destination url
    NSString *webDir = @"http://epanes.math.cmu.edu/json/";
    NSString *filename = @"default.json";
    
    NSHTTPURLResponse *response = nil;
    NSString *sourceStr = [NSString stringWithFormat:[webDir stringByAppendingString:filename]];
    NSURL *sourceUrl = [NSURL URLWithString:[sourceStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:sourceUrl
                             cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSMutableArray *result  = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    //NSLog(@"Result = %@", result);
    
    // get target url from the json file
    NSString *destStr;
    for (NSMutableDictionary *dic in result) {
        NSString *string = dic[@"project"];
        if (string) {
            // valid project field found
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            destStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"proejct json name = %@", destStr);
            break;
        } else {
            NSLog(@"Error in url response: %@", string);
        }
    }
    
    // display content of target url in the web view
    NSURL *destUrl = [NSURL URLWithString:[NSString stringWithFormat:[webDir
                                            stringByAppendingString:destStr]]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:destUrl];
    [_webView loadRequest:urlRequest];
    
    // essential initiations
    // register button with listener
    //[_titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (IBAction)titleButtonClick:(id)sender {
    NSString *destStr = [NSString stringWithFormat:@"http://www.google.com"];
    NSURL *destUrl = [NSURL URLWithString:destStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:destUrl];
    [_webView loadRequest:urlRequest];
}
*/


@end
