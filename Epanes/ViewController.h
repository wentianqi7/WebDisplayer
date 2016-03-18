//
//  ViewController.h
//  Epanes
//
//  Created by Rainy Yang on 2/17/16.
//  Copyright (c) 2016 Tianqi Wen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *titleButton;
@property (nonatomic) NSString *destStr;
@property NSMutableDictionary *projectMap;
@property NSMutableArray *history;
@end

