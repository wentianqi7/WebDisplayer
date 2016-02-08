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
    NSString *webDir = @"http://www.w3schools.com/json/";
    NSString *filename = @"myTutorials.txt";
    
    /*
    NSURL *sourceUrl = [NSURL URLWithString:[webDir stringByAppendingString:filename]];
    
    NSString *webData = [NSString stringWithContentsOfURL:sourceUrl
                                            encoding:NSASCIIStringEncoding
                                                    error:nil];
    */
    NSHTTPURLResponse *response = nil;
    NSString *sourceStr = [NSString stringWithFormat:[webDir stringByAppendingString:filename]];
    NSURL *sourceUrl = [NSURL URLWithString:[sourceStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:sourceUrl];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSMutableArray *result  = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    //NSLog(@"Result = %@", result);
    
    // get target url from the json file
    NSString *destStr;
    for (NSMutableDictionary *dic in result) {
        NSString *string = dic[@"url"];
        if (string) {
            NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
            //dic[@"url"] = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            destStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"url = %@", destStr);
            break;
        } else {
            NSLog(@"Error in url response");
        }
    }
    
    // display content of target url in the web view
    NSURL *destUrl = [NSURL URLWithString:destStr];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:destUrl];
    [_webView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
