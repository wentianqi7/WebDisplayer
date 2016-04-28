//
//  TableViewCell.m
//  Epanes
//
//  Created by Tianqi Wen on 2/29/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setFrame:(CGRect)frame {
    NSLog(@"set frame in cell called");
    if (self.superview) {
        frame.size.width = self.superview.frame.size.width;
        frame.size.height = self.superview.frame.size.height / 10;
    }
    [super setFrame:frame];
}


@end
