//
//  Utils.m
//  Epanes
//
//  Created by Tianqi Wen on 3/25/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import "Utils.h"

@implementation Utils

NSString *const WEB_DIR = @"http://epanes.math.cmu.edu";

// get json content from given website with filename
- (NSMutableArray *)getJsonContent:(NSString *)webDir filename:(NSString *)filename {
    NSHTTPURLResponse *response = nil;
    NSString *sourceStr = [NSString stringWithFormat:[webDir stringByAppendingString:filename]];
    NSURL *sourceUrl = [NSURL URLWithString:[sourceStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:sourceUrl
                                                  cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSMutableArray *result  = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    return result;
}

// encode the input string
- (NSString *)processString:(NSString *)inputStr {
    NSData *data = [inputStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *outputStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return outputStr;
}

- (void)loadFromUrl:(NSString *)destUrlStr view:(UIWebView *)currentView {
    NSURL *destUrl = [NSURL URLWithString:[destUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:destUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
    [currentView loadRequest:urlRequest];
}





@end
