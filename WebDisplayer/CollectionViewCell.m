//
//  CollectionViewCell.m
//  Epanes
//
//  Created by Tianqi Wen on 2/17/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell

- (void)awakeFromNib {
    
    // background color
    UIView *bgView = [[UIView alloc]initWithFrame:self.bounds];
    self.backgroundView = bgView;
    self.backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pic1"]];
    
    // selected background
    UIView *selectedView = [[UIView alloc]initWithFrame:self.bounds];
    self.selectedBackgroundView = selectedView;
    self.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"epanes"]];
}

@end
