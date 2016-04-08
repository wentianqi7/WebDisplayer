//
//  BackgroundView.m
//  Epanes
//
//  Created by Tianqi Wen on 4/8/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import "BackgroundView.h"
#import "ViewController.h"

@implementation BackgroundView
/*
- (UIView *) hitTest:(CGPoint) point withEvent:(UIEvent *) event {
    UIView *subView = (UIView *)[self viewWithTag:500];
    if (subView) {
        CGPoint pointForSubView = [subView convertPoint:point fromView:self];
        if (!CGRectContainsPoint(subView.bounds, pointForSubView)) {
            // touch outside of the menu (table view)
            NSLog(@"touched");
            ViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
            NSString *projID = [_projects objectAtIndex:indexPath.row];
            viewController.destStr = _idToUrlMap[projID];
            [self presentViewController:viewController animated:NO completion:nil];
        }
    }
    return [super hitTest:point withEvent:event];
}
*/
@end
