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
    _projectMap = [[NSMutableDictionary alloc] init];
    _utils = [[Utils alloc] init];

	// get url from default.json
	NSString *filename = @"/json/default.json";
	NSString *destStr;
	
    if (_destStr == NULL) {
        NSMutableArray *result = [_utils getJsonContent:WEB_DIR filename:filename];
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
