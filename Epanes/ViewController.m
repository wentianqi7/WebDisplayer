//
//  ViewController.m
//  Testing
//
//  Created by Tianqi Wen on 2/7/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import "ViewController.h"
#import "PopupViewController.h"
#import "DBManager.h"

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController



- (void)viewDidLoad {
	[super viewDidLoad];
    
    _history = [[NSMutableArray alloc] init];
    _urlToIdMap = [[NSMutableDictionary alloc] init];
    _utils = [[Utils alloc] init];

	// get url from default.json
	NSString *destStr;
	
    if (_destStr == NULL) {
        NSMutableArray *result = [_utils getJsonContent:WEB_DIR filename:DEFAULT_FILENAME];
        for (NSMutableDictionary *dic in result) {
            NSString *string = dic[@"url"];
            if (string) {
                // valid project field found
                destStr = [_utils processString:string];
                NSLog(@"webview loaded - dest: %@", destStr);
            }
        }
    } else {
        destStr = _destStr;
    }
	
	// set content of webview to the url
	[_utils loadFromUrl:destStr view:_webView];
	
	// register button with listener
	[_titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // get all valid projects
    NSMutableArray *projResult = [_utils getJsonContent:WEB_DIR filename:@"/projects.json"];
    for (NSMutableDictionary *dic in projResult) {
        NSString *urlStr = dic[@"url"];
        NSString *projID = dic[@"id"];
        if (urlStr) {
            [_urlToIdMap setValue:projID forKey:urlStr];
            NSLog(@"load project: %@, %@", projID, urlStr);
        }
    }
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (IBAction)titleButtonClick:(id)sender {
    PopupViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PopupViewController"];
    viewController.providesPresentationContextTransitionStyle = YES;
    viewController.definesPresentationContext = YES;
    [viewController setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self presentViewController:viewController animated:NO completion:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    _webView.delegate = self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *urlStr = request.mainDocumentURL.absoluteString;
    NSString *value = _urlToIdMap[urlStr];
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
