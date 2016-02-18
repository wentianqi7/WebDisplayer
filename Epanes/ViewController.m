//
//  ViewController.m
//  Testing
//
//  Created by Tianqi Wen on 2/7/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import "ViewController.h"
#import "CollectionViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	NSLog(@"web view display url = %@", _destStr);
	
	NSURL *destUrl = [NSURL URLWithString:[_destStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:destUrl];
	[_webView loadRequest:urlRequest];
	
	// essential initiations
	// register button with listener
	[_titleButton addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)titleButtonClick:(id)sender {
	/*
	NSString *destStr = [NSString stringWithFormat:@"http://www.google.com"];
	NSURL *destUrl = [NSURL URLWithString:destStr];
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:destUrl];
	[_webView loadRequest:urlRequest];
	 */
	CollectionViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CollectionViewController"];
	[self presentModalViewController:viewController animated:YES];
	
}



@end
