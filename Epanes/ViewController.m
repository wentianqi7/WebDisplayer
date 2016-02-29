//
//  ViewController.m
//  Testing
//
//  Created by Tianqi Wen on 2/7/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    _history = [[NSMutableArray alloc] init];
    _projects = [[NSMutableArray alloc] init];

	// get url from default.json
	NSString *webDir = @"http://epanes.math.cmu.edu/json/";
	NSString *filename = @"default.json";
	NSString *destStr;
	
	NSMutableArray *result = [self getJsonContent:webDir filename:filename];
	for (NSMutableDictionary *dic in result) {
		NSString *string = dic[@"url"];
		if (string) {
			// valid project field found
			destStr = [self processString:string];
			NSLog(@"webview loaded - dest: %@", destStr);
		}
	}
	
	// set content of webview to the url
	[self loadFromUrl:destStr];
	
	// register button with listener
	[_titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // get all valid projects
    NSMutableArray *projResult = [self getJsonContent:@"http://epanes.math.cmu.edu" filename:@"/projects.json"];
    for (NSMutableDictionary *dic in projResult) {
        NSString *string = dic[@"url"];
        if (string) {
            [_projects addObject:string];
            NSLog(@"load project: %@, %lu", string, _projects.count);
        }
    }
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)titleButtonClick:(id)sender {
	TableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];
	[self presentModalViewController:viewController animated:YES];
}

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

- (void)loadFromUrl:(NSString *)destUrlStr {
	NSURL *destUrl = [NSURL URLWithString:[destUrlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:destUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60.0];
	[_webView loadRequest:urlRequest];
}

-(void)viewWillAppear:(BOOL)animated {
    _webView.delegate = self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlStr = request.mainDocumentURL.absoluteString;
    if(![_history containsObject:urlStr]){
        [_history addObject:urlStr];
        NSLog(@"%@, %lu", urlStr, _history.count);
    } else {
        NSLog(@"already exist: %@, %lu", urlStr, _history.count);
    }
    return TRUE;
}

@end
