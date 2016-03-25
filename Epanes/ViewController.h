//
//  ViewController.h
//  Epanes
//
//  Created by Rainy Yang on 2/17/16.
//  Copyright (c) 2016 Tianqi Wen. All rights reserved.
//

#import "Utils.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *titleButton;
@property (nonatomic) NSString *destStr;
@property Utils *utils;
@property NSMutableDictionary *projectMap;
@property NSMutableArray *history;
@end

