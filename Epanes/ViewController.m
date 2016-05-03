//
//  ViewController.m
//  Testing
//
//  Created by Tianqi Wen on 2/7/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"

@interface ViewController ()<UIWebViewDelegate>

@end

@implementation ViewController


- (void)viewDidLoad {
	[super viewDidLoad];
    [self initVars];

	NSString *destStr;
    if (_destStr == NULL) {
        if (_isFirstTime == NULL && _prevProjects.count > 0) {
            // first time enter the app, with previous project viewed
            // go to last viewed page
            int prevId = [[_prevProjects objectAtIndex:0] intValue];

            NSMutableArray *tempResults = [_utils getJsonContent:WEB_DIR filename:PROJECT_FILE];
            for (NSMutableDictionary *dic in tempResults) {
                NSString *tempUrl = dic[URL];
                NSString *tempId = dic[ID];
                if ([tempId intValue] == prevId) {
                    destStr = tempUrl;
                }
            }
        } else {
            // first time enter the app, without previous projects viewed
            // get default homepage
            NSMutableArray *result = [_utils getJsonContent:WEB_DIR filename:DEFAULT_FILENAME];
            for (NSMutableDictionary *dic in result) {
                NSString *url = dic[URL];
                if (url) {
                    // valid project field found
                    destStr = [_utils processString:url];
                    NSLog(@"webview loaded - dest: %@", destStr);
                }
            }
        }
    } else {
        // not the first time enter the app
        // go to the targeted page in _destStr
        destStr = _destStr;
    }
	
	// set content of webview to the url
	[_utils loadFromUrl:destStr view:_webView];
    
    // get all valid projects
    NSMutableArray *projResult = [_utils getJsonContent:WEB_DIR filename:PROJECT_FILE];
    for (NSMutableDictionary *dic in projResult) {
        NSString *urlStr = dic[URL];
        NSString *title = dic[TITLE];
        NSString *projID = dic[ID];
        if (urlStr && title && projID) {
            [_urlToIdMap setValue:projID forKey:urlStr];
            Project newProj = {title, urlStr};
            [_idToProjectMap setObject:[NSValue value:&newProj withObjCType:@encode(Project)] forKey:projID];
            NSLog(@"add project: %@ %@ %@\n", projID, title, urlStr);
        }
    }
    
    // register button with listener
    [_titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) initVars {
    _history = [[NSMutableArray alloc] init];
    _urlToIdMap = [[NSMutableDictionary alloc] init];
    _prevProjects = [[NSMutableArray alloc] init];
    _idToProjectMap = [[NSMutableDictionary alloc] init];
    _utils = [[Utils alloc] init];
    
    _prevProjects = [[DBManager getSharedInstance] getRecentHistory:HISTORY_SIZE];
}

- (IBAction)titleButtonClick:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Project History" delegate:self
                                              cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    popup.tag = 1;
    _prevProjects = [[DBManager getSharedInstance] getRecentHistory:HISTORY_SIZE];
    NSLog(@"prev projects size : %lu", _prevProjects.count);
    for (NSString *idStr in _prevProjects) {
        Project tempProj;
        NSValue *value = _idToProjectMap[idStr];
        if (!value) {
            continue;
        }
        [value getValue:&tempProj];
        [popup addButtonWithTitle:tempProj.title];
    }
    [popup addButtonWithTitle:@"Show All Projects"];
    popup.cancelButtonIndex = [popup addButtonWithTitle:@"Cancel"];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        [popup showFromRect:_titleButton.frame inView:self.view animated:YES];
    } else {
        [popup showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)popup didDismissWithButtonIndex:(NSInteger)buttonIndex {
//- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (popup.tag) {
        case 1: {
            NSLog(@"button clicked %ld, %lu", buttonIndex, _prevProjects.count);
            // menu action sheet
            if (buttonIndex > _prevProjects.count) {
                return;
            }
            ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            if (buttonIndex < _prevProjects.count) {
                Project tempProj;
                NSValue *value = _idToProjectMap[[_prevProjects objectAtIndex:buttonIndex]];
                if (value) {
                    [value getValue:&tempProj];
                    viewController.destStr = tempProj.url;
                } else {
                    viewController.destStr = NULL;
                    viewController.isFirstTime = @"No";
                }
            } else {
                // show all projects
                viewController.destStr = NULL;
                viewController.isFirstTime = @"No";
            }
            [self presentViewController:viewController animated:NO completion:nil];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
    _webView.delegate = self;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(nonnull NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    _curUrl = request.mainDocumentURL.absoluteString;
    NSLog(@"current url = %@", _curUrl);
    NSString *value = _urlToIdMap[_curUrl];
    if (value) {
        // save data to database
        int projID = [value intValue];
        BOOL success = [[DBManager getSharedInstance] saveHistoryData:projID];
        if (success) {
            NSLog(@"!!!save %d to database", projID);
        } else {
            NSLog(@"!!!insert to database failed");
        }
    }
    return TRUE;
}


@end
