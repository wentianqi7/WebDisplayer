//
//  PopupViewController.m
//  Epanes
//
//  Created by Tianqi Wen on 3/25/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import "PopupViewController.h"
#import "TableViewController.h"

@interface PopupViewController ()

@end

@implementation PopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TableViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];

    // set up subview size
    CGFloat scaleX = 180/viewController.view.frame.size.width;
    CGFloat scaleY = 240/viewController.view.frame.size.height;
    CGFloat scale = MIN(scaleX, scaleY);
    
    viewController.view.transform = CGAffineTransformMakeScale(scale, scale);
    viewController.view.center = CGPointMake(viewController.view.frame.size.width/2, viewController.view.frame.size.height/2);
    [viewController.view setNeedsLayout];
    viewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 90, [UIScreen mainScreen].bounds.size.height / 2 - 120, 180, 240);
    [viewController.tableView setDelegate:viewController];
    [viewController.tableView setDataSource:viewController];
    
    [self.view addSubview:viewController.view];
    [self addChildViewController:viewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
