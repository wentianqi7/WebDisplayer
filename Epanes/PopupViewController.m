//
//  PopupViewController.m
//  Epanes
//
//  Created by Tianqi Wen on 3/25/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import "PopupViewController.h"
#import "ViewController.h"

@interface PopupViewController ()

@end

@implementation PopupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewController"];

    // set up subview size
    [self setSubViewSize];
    
    [_viewController.view setNeedsLayout];
    _viewController.view.tag = 500;
    [_viewController.tableView setDelegate:_viewController];
    [_viewController.tableView setDataSource:_viewController];
    
    [self.view addSubview:_viewController.view];
    [self addChildViewController:_viewController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    // CGPoint touchLocation = [touch locationInView:touch.view];
    NSLog(@"%@", touch.view);
    
    ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
    viewController.destStr = _prevStr;
    [self presentViewController:viewController animated:NO completion:nil];
}

-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self setSubViewSize];
    
}

-(void) setSubViewSize {
    if (_viewController == NULL) {
        return;
    }
    CGFloat scaleX = 180/self.view.frame.size.width;
    CGFloat scaleY = 240/self.view.frame.size.height;
    CGFloat scale = MIN(scaleX, scaleY);
    _viewController.view.transform = CGAffineTransformMakeScale(scale, scale);
    _viewController.view.center = CGPointMake(_viewController.view.frame.size.width/2, _viewController.view.frame.size.height/2);
    _viewController.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - 30/scaleX, [UIScreen mainScreen].bounds.size.height / 2 - 40/scaleY, 60/scaleX, 80/scaleY);
}

@end
