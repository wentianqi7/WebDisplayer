//
//  ViewController.m
//  Testing
//
//  Created by Tianqi Wen on 2/7/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import "ViewController.h"
#import "TableViewController.h"
#import "PopupViewController.h"
#import "DBManager.h"
#import <UIKit/UIKit.h>

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
    
    _history = [[NSMutableArray alloc] init];
    _projectMap = [[NSMutableDictionary alloc] init];

	// get url from default.json
	NSString *webDir = @"http://epanes.math.cmu.edu/json/";
	NSString *filename = @"default.json";
	NSString *destStr;
	
    if (_destStr == NULL) {
        NSMutableArray *result = [self getJsonContent:webDir filename:filename];
        for (NSMutableDictionary *dic in result) {
            NSString *string = dic[@"url"];
            if (string) {
                // valid project field found
                destStr = [self processString:string];
                NSLog(@"webview loaded - dest: %@", destStr);
            }
        }
    } else {
        destStr = _destStr;
    }
	
	// set content of webview to the url
	[self loadFromUrl:destStr];
	
	// register button with listener
	[_titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // get all valid projects
    NSMutableArray *projResult = [self getJsonContent:@"http://epanes.math.cmu.edu" filename:@"/projects.json"];
    for (NSMutableDictionary *dic in projResult) {
        NSString *string = dic[@"url"];
        NSString *projID = dic[@"id"];
        if (string) {
            [_projectMap setValue:projID forKey:string];
            NSLog(@"load project: %@, %@, %lu", projID, string, _projectMap.count);
        }
    }
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)titleButtonClick:(id)sender {
	//TableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];
    //[self presentModalViewController:viewController animated:YES];
    
    PopupViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PopupViewController"];
    viewController.providesPresentationContextTransitionStyle = YES;
    viewController.definesPresentationContext = YES;
    [viewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:viewController animated:NO completion:nil];
    
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
    NSString *value = _projectMap[urlStr];
    if (value) {
        // save data to database
        int projID = [value intValue];
        BOOL success = [[DBManager getSharedInstance] saveData:projID];
        if (success) {
            NSLog(@"save %d to database", projID);
        } else {
            NSLog(@"insert to database failed");
        }
    }
    return TRUE;
}

@end
