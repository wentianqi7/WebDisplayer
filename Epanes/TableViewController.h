//
//  TableViewController.h
//  Epanes
//
//  Created by Tianqi Wen on 2/29/16.
//  Copyright © 2016 Tianqi Wen. All rights reserved.
//

#import "Utils.h"

@interface TableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UIButton *tableButton;
@property NSMutableArray *projects;
@property NSMutableDictionary *projNameMap;
@property NSMutableDictionary *projUrlMap;
@property Utils* utils;
extern const int HISTORY_SIZE;
@end
