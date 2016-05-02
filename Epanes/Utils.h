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

extern NSString * const WEB_DIR;
extern NSString * const DEFAULT_FILENAME;
extern NSString * const PROJECT_FILE;
extern NSString * const URL;
extern NSString * const TITLE;
extern NSString * const ID;
extern int const HISTORY_SIZE;

@end
