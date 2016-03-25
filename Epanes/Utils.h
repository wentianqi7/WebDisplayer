//
//  Utils.h
//  Epanes
//
//  Created by Tianqi Wen on 3/25/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

- (NSMutableArray *)getJsonContent:(NSString *)webDir filename:(NSString *)filename;
- (NSString *)processString:(NSString *)inputStr;
- (void)loadFromUrl:(NSString *)destUrlStr view:(UIView *)currentView;

extern NSString *const WEB_DIR;

@end
