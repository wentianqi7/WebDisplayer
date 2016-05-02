//
//  ViewController.h
//  Epanes
//
//  Created by Rainy Yang on 2/17/16.
//  Copyright (c) 2016 Tianqi Wen. All rights reserved.
//

#import "Utils.h"

@interface ViewController : UIViewController

typedef struct {
    __unsafe_unretained NSString *title;
    __unsafe_unretained NSString *url;
} Project;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *titleButton;
@property (nonatomic) NSString *destStr;
@property Utils *utils;
@property NSMutableDictionary *urlToIdMap;
@property NSMutableDictionary *idToProjectMap;
@property NSMutableArray *prevProjects;
@property NSMutableArray *history;
@property NSString *curUrl;
@property NSString *isFirstTime;
@end

